---
description: Extract or query parts of a Markdown document by structure (headings, lists, links, code blocks, tables, front matter) instead of sed/grep/awk. Read-only.
name: mdq
---

# When

REACH for `mdq` whenever you would otherwise `sed`/`grep`/`awk` a Markdown file to
pull out a part of it: a section under a heading, list items, links, code blocks,
tables, or front matter. It PARSES the Markdown structure, so it does NOT break on
blank lines, nested lists, or fenced code the way line-based tools do.

`mdq` is READ-ONLY: it SELECTS and PRINTS matching content. It does NOT edit or
rewrite in place. For a rewrite, extract with `mdq`, transform, and write the file
back yourself.

# Execution

1. PIPE the Markdown in on stdin; PASS the selector as the single argument:
   ```sh
   cat FILE.md | mdq 'SELECTOR'
   ```
2. CHAIN selectors with `|` to narrow (heading, then its list, then its links):
   ```sh
   cat FILE.md | mdq '# Implementation | 1. | [](^https://)'
   ```
3. ADD `--output json` when the caller needs structured output, or `-q` for an
   exit-code-only existence check.

# Selectors

| Target                   | Syntax                                          |
| ------------------------ | ----------------------------------------------- |
| Heading + its section    | `# heading text`                                |
| Unordered / ordered list | `- item` / `1. item`                            |
| Tasks                    | `- [ ]` unchecked, `- [x]` checked, `- [?]` any |
| Links / images           | `[text](url)` / `![alt](url)`                   |
| Block quotes             | `> text`                                        |
| Code blocks              | `` ```lang code ``                              |
| Paragraphs               | `P: text`                                       |
| Tables                   | `:-: header :-: row`                            |
| Front matter             | `+++[yaml\|toml] text`                          |

Text match: unquoted is case-insensitive, `"quoted"` is case-sensitive, `/regex/`
for patterns, `^start` / `end$` anchors, `*` wildcard.

# Examples

```sh
# Pull just the "Implementation" section out of a ticket
cat ticket.md | mdq '# Implementation'

# All unchecked tasks across a doc
cat plan.md | mdq '- [ ]'

# Ticket links pointing at the tracker
cat ticket.md | mdq '# Ticket | [](^https://tickets\.example\.com/[A-Z]+-\d+$)'
```
