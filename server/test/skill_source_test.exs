defmodule Wiki.Content.SkillSourceTest do
  use Wiki.ContentCase, async: false

  @source "repo1:demo/SKILL.md"
  @skill "---\nname: demo\ndescription: Full trigger and exclusion.\n---\n\n# Demo\n\n## Steps\n1. Preserve every instruction.\n\n```text\n[[example-only]]\n```\n"

  setup %{dir: dir} do
    root = Path.join(dir, "dev")
    File.mkdir_p!(Path.join(root, "repo1/demo"))
    File.write!(Path.join(root, "repo1/demo/SKILL.md"), @skill)
    System.put_env("WIKI_DEV_ROOT", root)
    on_exit(fn -> System.delete_env("WIKI_DEV_ROOT") end)
    :ok
  end

  defp snapshot(text \\ @skill) do
    hash = :crypto.hash(:sha256, text) |> Base.encode16(case: :lower)
    "````skill-source #{@source} #{hash}\n#{text}````\n"
  end

  defp skill(c, notes, sources \\ [@source]) do
    valid_wiki(c)

    write_page(c, "skill-demo", base_header("skill-demo", kind: "skill", sources: sources), %{
      "what" => "See [[a]].",
      "steps" => "1. A readable explanation.",
      "notes" => notes
    })
  end

  # REQ CO-10
  test "a summary alone is rejected even with a Steps section", %{content: c} do
    skill(c, "A short summary.")
    assert Enum.any?(Check.run(Store.load(c)), &(&1 =~ "complete SKILL.md"))
    skill(c, snapshot(), [])
    assert Enum.any?(Check.run(Store.load(c)), &(&1 =~ "SKILL.md source"))
  end

  # REQ CO-10
  test "the full file survives parsing and building in every language", %{content: c, dir: dir} do
    skill(c, snapshot())
    store = Store.load(c)
    assert Check.run(store, local: true) == []
    assert store.pages["skill-demo"].errors == []
    assert Page.section(store.pages["skill-demo"], "notes") =~ @skill
    refute "example-only" in Page.links(store.pages["skill-demo"])
    out = Path.join(dir, "site")
    Build.run(store, out)

    for lang <- Store.langs() do
      article = File.read!(Path.join(out, "data/pages/skill-demo.#{lang}.json")) |> JSON.decode!()
      assert Enum.find(article["sections"], &(&1["key"] == "notes"))["markdown"] =~ @skill
    end
  end

  # REQ CO-10
  test "tampering is rejected offline and an updated fingerprint cannot hide truncation locally",
       %{content: c} do
    skill(c, String.replace(snapshot(), "Preserve every instruction.", "Shortened."))
    assert Enum.any?(Check.run(Store.load(c)), &(&1 =~ "fingerprint"))
    skill(c, snapshot(String.replace(@skill, "1. Preserve every instruction.\n", "")))
    assert Enum.any?(Check.run(Store.load(c), local: true), &(&1 =~ "differs from"))
  end

  # REQ CO-10
  test "source changes require a refreshed copy and translations cannot drop it", %{
    content: c,
    dir: dir
  } do
    skill(c, snapshot())
    File.write!(Path.join(dir, "dev/repo1/demo/SKILL.md"), @skill <> "New rule.\n")
    assert Enum.any?(Check.run(Store.load(c), local: true), &(&1 =~ "differs from"))
    file = Path.join(c, "skill-demo.de.md")

    File.write!(
      file,
      File.read!(file) |> String.replace(snapshot() |> String.trim(), "No source.")
    )

    assert Enum.any?(
             Check.run(Store.load(c)),
             &(&1 =~ "skill-demo.de.md" and &1 =~ "complete SKILL.md")
           )
  end

  # REQ CO-10
  test "all declared variants need snapshots and non-skill pages do not", %{content: c} do
    skill(c, snapshot(), [@source, "repo1:other/SKILL.md"])
    assert Enum.any?(Check.run(Store.load(c)), &(&1 =~ "repo1:other/SKILL.md"))
    valid_wiki(c)
    File.rm!(Path.join(c, "skill-demo.md"))
    for lang <- Store.translation_langs(), do: File.rm!(Path.join(c, "skill-demo.#{lang}.md"))
    assert Check.run(Store.load(c), local: true) == []
  end
end
