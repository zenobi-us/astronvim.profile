# AGENTS.md


## Project Guidelines

- never commit binaries
- when adjusting .gitignore, stop. get human help.
- **[ABSOLUTELY UNVOIDABLE]** After every git commit, update README.md with:
  - `## Plugins` - short list summarizing neovim plugins used
  - `## Keymaps` - buffer > mode > keymap reference tables with subheaders
  - `### Keymaps > Quickstart` - quick list of common tasks with keymap links
  - Use writing/documentation skills to maintain clarity and consistency

## In-Memoria Intelligence (Codebase Navigation)

**When to use In-Memoria** (prefer over manual grep/glob):

- [ALWAYS] When asked "where should I..." or "what files..." → Use `memoria_predict_coding_approach`
- [ALWAYS] When searching for patterns across codebase → Use `memoria_search_codebase`
- [START OF SESSION] Get project overview → Use `memoria_get_project_blueprint`
- [BEFORE REFACTORING] Check existing patterns → Use `memoria_get_pattern_recommendations`

**Quick commands:**

```bash
# Project overview (run once per session)
memoria_get_project_blueprint(path="$(pwd)")

# Find files for a task
memoria_predict_coding_approach(problemDescription="add task filtering by assignee")

# Search for pattern usage
memoria_search_codebase(query="ProjectService", type="text")

# Get recommended patterns for new code
memoria_get_pattern_recommendations(problemDescription="create new service class")
```

**Benefits:**

- ✅ 10-100x faster than manual grep/find
- ✅ Learns project patterns (Factory, Builder, Service patterns)
- ✅ No more "exploring to understand" - instant routing
- ✅ Confidence scores guide decisions

**When NOT to use:**

- Reading specific known files → Use `read` tool directly
- Exact file path operations → Use bash/filesystem tools
