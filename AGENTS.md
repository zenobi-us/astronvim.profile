# AGENTS.md

## Project Guidelines

- never commit binaries
- when adjusting .gitignore, stop. get human help.
- **[ABSOLUTELY UNVOIDABLE]** After every git commit, update README.md with:
  - `## Plugins` - short list summarizing neovim plugins used
  - `## Keymaps` - buffer > mode > keymap reference tables with subheaders
  - `### Keymaps > Quickstart` - quick list of common tasks with keymap links
  - Use writing/documentation skills to maintain clarity and consistency

## Style

### Plugins

- each plugin defintion in it's own file under `lua/plugins/`
- plugin files named after plugin, e.g. `lua/plugins/telescope.lua`
- The only plugin allowed to contain keymaps is @lua/plugins/astrocore.lua
- use below template for plugin files:

```lua
-- Plugin: telescope.nvim
-- Description: Fuzzy finder and more
-- URL: some url
---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      -- your telescope config here
    })
  end,
}
```

### Custom Plugins

Custom plugins are ones that we completely own and maintain. They follow a more verbose file structure to encourage clarity and maintainability.

- They live under`lua/custom/<namespace>/<plugin_name>.nvim/`
- Custom plugins are still loaded in `lua/plugins/<plugin_name>.lua` using lazy.nvim
- Use `<namespace>` to group related plugins (e.g. `astrocore`, `myutils`, `inmemoria`, etc)
- `<plugin_name>` should be descriptive of the plugin's purpose (e.g. `taskmanager`, `codeformatter`, etc)
- Each custom plugin has the following structure:

```
lua/custom/
  <namespace>/
    <plugin_name>.nvim/
      init.lua                          -- entrypoint (loads <namespace>-<plugin_name>/init.lua)
      lua/
        <namespace>-<plugin_name>/      -- plugin code
          init.lua                      -- plugin modules
      help/
        <namespace>-<plugin_name>.md    -- plugin documentation
      tests/
        <test_files>.lua                -- plugin tests
```

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
