# Wiki content work

Read `CLAUDE.md` for the project structure, chosen languages, quality gate and existing content rules. Use `wiki-page-writer` for page work.

## Complete skill pages (CO-10)

When a page has `kind: skill`, locate and read its complete installed `SKILL.md` before writing. Use the page's sources and location, and search installed skill folders when needed. Document separate Claude and Codex versions explicitly when both exist.

Keep the readable explanation and Steps. In Notes, include the complete original source file: its frontmatter description, every instruction, example, limit and reference path. A shortened description, summary or link alone does not meet this rule. Retain the same original source in German and Portuguese pages, introduced in the page's language; translate the surrounding explanation. Referenced auxiliary files are not automatically included in this source copy.

Each copy uses a fenced block with info `skill-source <repo:path/to/SKILL.md> <sha256>`. Choose a backtick fence longer than any run inside the source. Compute the fingerprint over the entire text after normalizing line endings to LF and adding a final newline only when absent. List each original file in `sources`. Never truncate a source to satisfy validation; report unavailable or privacy-blocked sources.

Refresh copies whenever the sources change. Run `wiki check --local`: it compares the copies to the installed files and checks that translations retain them. The check without local files validates presence and fingerprints, but cannot verify freshness against unavailable sources.
