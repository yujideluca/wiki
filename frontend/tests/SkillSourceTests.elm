module SkillSourceTests exposing (tests)

import Expect
import Test exposing (Test, describe, test)
import WikiText


tests : Test
tests =
    describe "REQ CO-10: complete source is displayed without rewriting its examples"
        [ test "nested backticks do not turn source examples into live wiki links" <|
            \_ ->
                let
                    source =
                        "````skill-source home:demo/SKILL.md hash\n# Demo\nKeep [[literal]] as written.\n```text\n[[sample]]\n```\nUse `[[id]]`.\n````"

                    input =
                        "See [[real]].\n\n" ++ source ++ "\n\nThen [[other]]."
                in
                WikiText.rewriteLinks identity input
                    |> Expect.equal ("See [real](/p/real).\n\n" ++ source ++ "\n\nThen [other](/p/other).")
        ]
