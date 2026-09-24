-- Highlight groups for the vendored `rose-pine` colorschemes.
--
-- Ported from rose-pine/neovim, `lua/rose-pine.lua`, at the commit pinned in
-- `lazy-lock.json` before that plugin was dropped. Upstream is MIT licensed.
--
-- The two highlight tables below are upstream's `legacy_highlights` and
-- `default_highlights`, copied with one mechanical rename:
--
--   palette.X    -> p.X
--   groups.X     -> g.X
--   styles.bold  -> bold
--   styles.italic-> italic
--
-- Upstream reads its settings from `rose-pine.config`. This port has no
-- settings. It freezes the upstream defaults:
--
--   styles.bold                       = true
--   styles.italic                     = true
--   styles.transparency               = false  -> `transparency_highlights` is not copied
--   dim_inactive_windows              = false  -> NormalNC uses `base`, never `_nc`
--   extend_background_behind_borders  = true   -> `make_border` paints `surface`
--   enable.legacy_highlights          = true   -> the legacy table is copied
--   highlight_groups / before_highlight        -> no user hooks, so no reconcile pass
--
-- A dump of all 1085 highlight groups matches upstream exactly, except for
-- three deliberate deviations:
--
--   1. `DiffviewStatusUntracked` and `DiffviewStatusCopied` read
--      `groups.untracked` upstream. No such role exists, so upstream sets
--      those groups to an empty table. Here they read `git_untracked`, which
--      is the role the name points at.
--   2. Colours are plain hex, so `blend` is resolved by
--      `zenobius-themes.blend` instead of upstream's `nvim_get_color_by_name`
--      path.
--   3. On `rose-pine-dawn` only, four groups that neither upstream nor this
--      port sets keep Neovim's light built-in defaults here, and its dark
--      ones upstream: `DiagnosticDeprecated`, `FloatShadow`,
--      `FloatShadowThrough`, `OkMsg`. Upstream sets `g:colors_name` before
--      `background`, which makes Neovim re-source the colorscheme and skip
--      the default re-init for the new background. `zenobius-themes.init`
--      sets `background` first, so a light theme gets the light defaults.
--
-- To re-sync with upstream, repeat the rename above on the new source.

local blend = require "zenobius-themes.blend"
local palettes = require "zenobius-themes.palettes.rose-pine"

local bold = true
local italic = true

---Map palette colours onto upstream's semantic role names.
---Upstream builds this from `config.options.groups`, which this port freezes.
---@param p table a variant from `zenobius-themes.palettes.rose-pine`
---@return table<string, string>
local function roles(p)
  return {
    border = p.muted,
    link = p.iris,
    panel = p.surface,

    error = p.love,
    hint = p.iris,
    info = p.foam,
    ok = p.leaf,
    warn = p.gold,
    note = p.pine,
    todo = p.rose,

    git_add = p.foam,
    git_change = p.rose,
    git_delete = p.love,
    git_dirty = p.rose,
    git_ignore = p.muted,
    git_merge = p.iris,
    git_rename = p.pine,
    git_stage = p.iris,
    git_text = p.rose,
    git_untracked = p.subtle,

    h1 = p.iris,
    h2 = p.foam,
    h3 = p.rose,
    h4 = p.gold,
    h5 = p.pine,
    h6 = p.leaf,
  }
end

local M = {}

---Build the full highlight table for one variant.
---@param variant RosePineVariant
---@return table<string, vim.api.keyset.highlight>
function M.groups(variant)
  local p = assert(palettes[variant], "unknown rose-pine variant: " .. tostring(variant))
  local g = roles(p)

  ---@param fg string|nil border colour, defaults to the `border` role
  local function make_border(fg) return { fg = fg or g.border, bg = p.surface } end

  local legacy = {
    ["@attribute.diff"] = { fg = p.gold },
    ["@boolean"] = { link = "Boolean" },
    ["@class"] = { fg = p.foam },
    ["@conditional"] = { link = "Conditional" },
    ["@field"] = { fg = p.foam },
    ["@include"] = { link = "Include" },
    ["@interface"] = { fg = p.foam },
    ["@macro"] = { link = "Macro" },
    ["@method"] = { fg = p.rose },
    ["@namespace"] = { link = "Include" },
    ["@number"] = { link = "Number" },
    ["@parameter"] = { fg = p.iris, italic = italic },
    ["@preproc"] = { link = "PreProc" },
    ["@punctuation"] = { fg = p.subtle },
    ["@punctuation.bracket"] = { link = "@punctuation" },
    ["@punctuation.delimiter"] = { link = "@punctuation" },
    ["@punctuation.special"] = { link = "@punctuation" },
    ["@regexp"] = { link = "String" },
    ["@repeat"] = { link = "Repeat" },
    ["@storageclass"] = { link = "StorageClass" },
    ["@symbol"] = { link = "Identifier" },
    ["@text"] = { fg = p.text },
    ["@text.danger"] = { fg = g.error },
    ["@text.diff.add"] = { fg = g.git_add, bg = g.git_add, blend = 20 },
    ["@text.diff.delete"] = { fg = g.git_delete, bg = g.git_delete, blend = 20 },
    ["@text.emphasis"] = { italic = italic },
    ["@text.environment"] = { link = "Macro" },
    ["@text.environment.name"] = { link = "Type" },
    ["@text.math"] = { link = "Special" },
    ["@text.note"] = { link = "SpecialComment" },
    ["@text.strike"] = { strikethrough = true },
    ["@text.strong"] = { bold = bold },
    ["@text.title"] = { link = "Title" },
    ["@text.title.1.markdown"] = { link = "markdownH1" },
    ["@text.title.1.marker.markdown"] = { link = "markdownH1Delimiter" },
    ["@text.title.2.markdown"] = { link = "markdownH2" },
    ["@text.title.2.marker.markdown"] = { link = "markdownH2Delimiter" },
    ["@text.title.3.markdown"] = { link = "markdownH3" },
    ["@text.title.3.marker.markdown"] = { link = "markdownH3Delimiter" },
    ["@text.title.4.markdown"] = { link = "markdownH4" },
    ["@text.title.4.marker.markdown"] = { link = "markdownH4Delimiter" },
    ["@text.title.5.markdown"] = { link = "markdownH5" },
    ["@text.title.5.marker.markdown"] = { link = "markdownH5Delimiter" },
    ["@text.title.6.markdown"] = { link = "markdownH6" },
    ["@text.title.6.marker.markdown"] = { link = "markdownH6Delimiter" },
    ["@text.underline"] = { underline = true },
    ["@text.uri"] = { fg = g.link },
    ["@text.warning"] = { fg = g.warn },
    ["@todo"] = { link = "Todo" },

    -- lukas-reineke/indent-blankline.nvim
    IndentBlanklineChar = { fg = p.muted, nocombine = true },
    IndentBlanklineSpaceChar = { fg = p.muted, nocombine = true },
    IndentBlanklineSpaceCharBlankline = { fg = p.muted, nocombine = true },
  }

  local default = {
    ColorColumn = { bg = p.surface },
    Conceal = { bg = "NONE" },
    CurSearch = { fg = p.base, bg = p.gold },
    Cursor = { fg = p.text, bg = p.highlight_high },
    CursorColumn = { bg = p.overlay },
    -- CursorIM = {},
    CursorLine = { bg = p.overlay },
    CursorLineNr = { fg = p.text, bold = bold },
    -- DarkenedPanel = { },
    -- DarkenedStatusline = {},
    DiffAdd = { bg = g.git_add, blend = 20 },
    DiffChange = { bg = g.git_change, blend = 20 },
    DiffDelete = { bg = g.git_delete, blend = 20 },
    DiffText = { bg = g.git_text, blend = 40 },
    diffAdded = { link = "DiffAdd" },
    diffChanged = { link = "DiffChange" },
    diffRemoved = { link = "DiffDelete" },
    Directory = { fg = p.foam, bold = bold },
    -- EndOfBuffer = {},
    ErrorMsg = { fg = g.error, bold = bold },
    FloatBorder = make_border(),
    FloatTitle = { fg = p.foam, bg = g.panel, bold = bold },
    FoldColumn = { fg = p.muted },
    Folded = { fg = p.text, bg = g.panel },
    IncSearch = { link = "CurSearch" },
    LineNr = { fg = p.muted },
    MatchParen = { fg = p.pine, bg = p.pine, blend = 25 },
    ModeMsg = { fg = p.subtle },
    MoreMsg = { fg = p.iris },
    NonText = { fg = p.muted },
    Normal = { fg = p.text, bg = p.base },
    NormalFloat = { bg = g.panel },
    NormalNC = { fg = p.text, bg = p.base },
    NvimInternalError = { link = "ErrorMsg" },
    Pmenu = { fg = p.subtle, bg = g.panel },
    PmenuExtra = { fg = p.muted, bg = g.panel },
    PmenuExtraSel = { fg = p.subtle, bg = p.overlay },
    PmenuKind = { fg = p.foam, bg = g.panel },
    PmenuKindSel = { fg = p.subtle, bg = p.overlay },
    PmenuSbar = { bg = g.panel },
    PmenuSel = { fg = p.text, bg = p.overlay },
    PmenuThumb = { bg = p.muted },
    Question = { fg = p.gold },
    QuickFixLine = { fg = p.foam },
    -- RedrawDebugNormal = {},
    RedrawDebugClear = { fg = p.base, bg = p.gold },
    RedrawDebugComposed = { fg = p.base, bg = p.pine },
    RedrawDebugRecompose = { fg = p.base, bg = p.love },
    Search = { fg = p.text, bg = p.gold, blend = 20 },
    SignColumn = { fg = p.text, bg = "NONE" },
    SpecialKey = { fg = p.foam },
    SpellBad = { sp = p.subtle, undercurl = true },
    SpellCap = { sp = p.subtle, undercurl = true },
    SpellLocal = { sp = p.subtle, undercurl = true },
    SpellRare = { sp = p.subtle, undercurl = true },
    StatusLine = { fg = p.subtle, bg = g.panel },
    StatusLineNC = { fg = p.muted, bg = g.panel, blend = 60 },
    StatusLineTerm = { fg = p.base, bg = p.pine },
    StatusLineTermNC = { fg = p.base, bg = p.pine, blend = 60 },
    Substitute = { link = "IncSearch" },
    TabLine = { fg = p.subtle, bg = g.panel },
    TabLineFill = { bg = g.panel },
    TabLineSel = { fg = p.text, bg = p.overlay, bold = bold },
    Title = { fg = p.foam, bold = bold },
    VertSplit = { fg = g.border },
    Visual = { bg = p.iris, blend = 15 },
    -- VisualNOS = {},
    WarningMsg = { fg = g.warn, bold = bold },
    -- Whitespace = {},
    WildMenu = { link = "IncSearch" },
    WinBar = { fg = p.subtle, bg = g.panel },
    WinBarNC = { fg = p.muted, bg = g.panel, blend = 60 },
    WinSeparator = { fg = g.border },

    DiagnosticError = { fg = g.error },
    DiagnosticHint = { fg = g.hint },
    DiagnosticInfo = { fg = g.info },
    DiagnosticOk = { fg = g.ok },
    DiagnosticWarn = { fg = g.warn },
    DiagnosticDefaultError = { link = "DiagnosticError" },
    DiagnosticDefaultHint = { link = "DiagnosticHint" },
    DiagnosticDefaultInfo = { link = "DiagnosticInfo" },
    DiagnosticDefaultOk = { link = "DiagnosticOk" },
    DiagnosticDefaultWarn = { link = "DiagnosticWarn" },
    DiagnosticFloatingError = { link = "DiagnosticError" },
    DiagnosticFloatingHint = { link = "DiagnosticHint" },
    DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    DiagnosticFloatingOk = { link = "DiagnosticOk" },
    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    DiagnosticSignError = { link = "DiagnosticError" },
    DiagnosticSignHint = { link = "DiagnosticHint" },
    DiagnosticSignInfo = { link = "DiagnosticInfo" },
    DiagnosticSignOk = { link = "DiagnosticOk" },
    DiagnosticSignWarn = { link = "DiagnosticWarn" },
    DiagnosticUnderlineError = { sp = g.error, undercurl = true },
    DiagnosticUnderlineHint = { sp = g.hint, undercurl = true },
    DiagnosticUnderlineInfo = { sp = g.info, undercurl = true },
    DiagnosticUnderlineOk = { sp = g.ok, undercurl = true },
    DiagnosticUnderlineWarn = { sp = g.warn, undercurl = true },
    DiagnosticVirtualTextError = { fg = g.error, bg = g.error, blend = 10 },
    DiagnosticVirtualTextHint = { fg = g.hint, bg = g.hint, blend = 10 },
    DiagnosticVirtualTextInfo = { fg = g.info, bg = g.info, blend = 10 },
    DiagnosticVirtualTextOk = { fg = g.ok, bg = g.ok, blend = 10 },
    DiagnosticVirtualTextWarn = { fg = g.warn, bg = g.warn, blend = 10 },

    Boolean = { fg = p.rose },
    Character = { fg = p.gold },
    Comment = { fg = p.subtle, italic = italic },
    Conditional = { fg = p.pine },
    Constant = { fg = p.gold },
    Debug = { fg = p.rose },
    Define = { fg = p.iris },
    Delimiter = { fg = p.subtle },
    Error = { fg = p.love },
    Exception = { fg = p.pine },
    Float = { fg = p.gold },
    Function = { fg = p.rose },
    Identifier = { fg = p.text },
    Include = { fg = p.pine },
    Keyword = { fg = p.pine },
    Label = { fg = p.foam },
    LspCodeLens = { fg = p.subtle },
    LspCodeLensSeparator = { fg = p.muted },
    LspInlayHint = { fg = p.muted, bg = p.muted, blend = 10 },
    LspReferenceRead = { bg = p.highlight_med },
    LspReferenceText = { bg = p.highlight_med },
    LspReferenceWrite = { bg = p.highlight_med },
    Macro = { fg = p.iris },
    Number = { fg = p.gold },
    Operator = { fg = p.subtle },
    PreCondit = { fg = p.iris },
    PreProc = { link = "PreCondit" },
    Repeat = { fg = p.pine },
    Special = { fg = p.foam },
    SpecialChar = { link = "Special" },
    SpecialComment = { fg = p.iris },
    Statement = { fg = p.pine, bold = bold },
    StorageClass = { fg = p.foam },
    String = { fg = p.gold },
    Structure = { fg = p.foam },
    Tag = { fg = p.foam },
    Todo = { fg = p.rose, bg = p.rose, blend = 20 },
    Type = { fg = p.foam },
    TypeDef = { link = "Type" },
    Underlined = { fg = p.iris, underline = true },
    Added = { fg = g.git_add },
    Changed = { fg = g.git_change },
    Removed = { fg = g.git_delete },

    healthError = { fg = g.error },
    healthSuccess = { fg = g.info },
    healthWarning = { fg = g.warn },

    htmlArg = { fg = p.iris },
    htmlBold = { bold = bold },
    htmlEndTag = { fg = p.subtle },
    htmlH1 = { link = "markdownH1" },
    htmlH2 = { link = "markdownH2" },
    htmlH3 = { link = "markdownH3" },
    htmlH4 = { link = "markdownH4" },
    htmlH5 = { link = "markdownH5" },
    htmlItalic = { italic = italic },
    htmlLink = { link = "markdownUrl" },
    htmlTag = { fg = p.subtle },
    htmlTagN = { fg = p.text },
    htmlTagName = { fg = p.foam },

    markdownDelimiter = { fg = p.subtle },
    markdownH1 = { fg = g.h1, bold = bold },
    markdownH1Delimiter = { link = "markdownH1" },
    markdownH2 = { fg = g.h2, bold = bold },
    markdownH2Delimiter = { link = "markdownH2" },
    markdownH3 = { fg = g.h3, bold = bold },
    markdownH3Delimiter = { link = "markdownH3" },
    markdownH4 = { fg = g.h4, bold = bold },
    markdownH4Delimiter = { link = "markdownH4" },
    markdownH5 = { fg = g.h5, bold = bold },
    markdownH5Delimiter = { link = "markdownH5" },
    markdownH6 = { fg = g.h6, bold = bold },
    markdownH6Delimiter = { link = "markdownH6" },
    markdownLinkText = { link = "markdownUrl" },
    markdownUrl = { fg = g.link, sp = g.link, underline = true },

    mkdCode = { fg = p.foam, italic = italic },
    mkdCodeDelimiter = { fg = p.rose },
    mkdCodeEnd = { fg = p.foam },
    mkdCodeStart = { fg = p.foam },
    mkdFootnotes = { fg = p.foam },
    mkdID = { fg = p.foam, underline = true },
    mkdInlineURL = { link = "markdownUrl" },
    mkdLink = { link = "markdownUrl" },
    mkdLinkDef = { link = "markdownUrl" },
    mkdListItemLine = { fg = p.text },
    mkdRule = { fg = p.subtle },
    mkdURL = { link = "markdownUrl" },

    --- Treesitter
    --- |:help treesitter-highlight-groups|
    ["@variable"] = { fg = p.text, italic = italic },
    ["@variable.builtin"] = { fg = p.love, italic = italic, bold = bold },
    ["@variable.parameter"] = { fg = p.iris, italic = italic },
    ["@variable.parameter.builtin"] = { fg = p.iris, italic = italic, bold = bold },
    ["@variable.member"] = { fg = p.foam },

    ["@constant"] = { fg = p.gold },
    ["@constant.builtin"] = { fg = p.gold, bold = bold },
    ["@constant.macro"] = { fg = p.gold },

    ["@module"] = { fg = p.text },
    ["@module.builtin"] = { fg = p.text, bold = bold },
    ["@label"] = { link = "Label" },

    ["@string"] = { link = "String" },
    -- ["@string.documentation"] = {},
    ["@string.regexp"] = { fg = p.iris },
    ["@string.escape"] = { fg = p.pine },
    ["@string.special"] = { link = "String" },
    ["@string.special.symbol"] = { link = "Identifier" },
    ["@string.special.url"] = { fg = g.link },
    -- ["@string.special.path"] = {},

    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "Character" },

    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Number" },
    ["@float"] = { link = "Number" },

    ["@type"] = { fg = p.foam },
    ["@type.builtin"] = { fg = p.foam, bold = bold },
    -- ["@type.definition"] = {},

    ["@attribute"] = { fg = p.iris },
    ["@attribute.builtin"] = { fg = p.iris, bold = bold },
    ["@property"] = { fg = p.foam, italic = italic },

    ["@function"] = { fg = p.rose },
    ["@function.builtin"] = { fg = p.rose, bold = bold },
    -- ["@function.call"] = {},
    ["@function.macro"] = { link = "Function" },

    ["@function.method"] = { fg = p.rose },
    ["@function.method.call"] = { fg = p.iris },

    ["@constructor"] = { fg = p.foam },
    ["@operator"] = { link = "Operator" },

    ["@keyword"] = { link = "Keyword" },
    -- ["@keyword.coroutine"] = {},
    -- ["@keyword.function"] = {},
    ["@keyword.operator"] = { fg = p.subtle },
    ["@keyword.import"] = { fg = p.pine },
    ["@keyword.storage"] = { fg = p.foam },
    ["@keyword.repeat"] = { fg = p.pine },
    ["@keyword.return"] = { fg = p.pine },
    ["@keyword.debug"] = { fg = p.rose },
    ["@keyword.exception"] = { fg = p.pine },

    ["@keyword.conditional"] = { fg = p.pine },
    ["@keyword.conditional.ternary"] = { fg = p.pine },

    ["@keyword.directive"] = { fg = p.iris },
    ["@keyword.directive.define"] = { fg = p.iris },

    --- Punctuation
    ["@punctuation.delimiter"] = { fg = p.subtle },
    ["@punctuation.bracket"] = { fg = p.subtle },
    ["@punctuation.special"] = { fg = p.subtle },

    --- Comments
    ["@comment"] = { link = "Comment" },
    -- ["@comment.documentation"] = {},

    ["@comment.error"] = { fg = g.error },
    ["@comment.warning"] = { fg = g.warn },
    ["@comment.todo"] = { fg = g.todo, bg = g.todo, blend = 15 },
    ["@comment.hint"] = { fg = g.hint, bg = g.hint, blend = 15 },
    ["@comment.info"] = { fg = g.info, bg = g.info, blend = 15 },
    ["@comment.note"] = { fg = g.note, bg = g.note, blend = 15 },

    --- Markup
    ["@markup.strong"] = { bold = bold },
    ["@markup.italic"] = { italic = italic },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },

    ["@markup.heading"] = { fg = p.foam, bold = bold },

    ["@markup.quote"] = { fg = p.text },
    ["@markup.math"] = { link = "Special" },
    ["@markup.environment"] = { link = "Macro" },
    ["@markup.environment.name"] = { link = "@type" },

    -- ["@markup.link"] = {},
    ["@markup.link.markdown_inline"] = { fg = p.subtle },
    ["@markup.link.label.markdown_inline"] = { fg = p.foam },
    ["@markup.link.url"] = { fg = g.link },

    -- ["@markup.raw"] = { bg = p.surface },
    -- ["@markup.raw.block"] = { bg = p.surface },
    ["@markup.raw.delimiter.markdown"] = { fg = p.subtle },

    ["@markup.list"] = { fg = p.pine },
    ["@markup.list.checked"] = { fg = p.foam, bg = p.foam, blend = 10 },
    ["@markup.list.unchecked"] = { fg = p.text },

    -- Markdown headings
    ["@markup.heading.1.markdown"] = { link = "markdownH1" },
    ["@markup.heading.2.markdown"] = { link = "markdownH2" },
    ["@markup.heading.3.markdown"] = { link = "markdownH3" },
    ["@markup.heading.4.markdown"] = { link = "markdownH4" },
    ["@markup.heading.5.markdown"] = { link = "markdownH5" },
    ["@markup.heading.6.markdown"] = { link = "markdownH6" },
    ["@markup.heading.1.marker.markdown"] = { link = "markdownH1Delimiter" },
    ["@markup.heading.2.marker.markdown"] = { link = "markdownH2Delimiter" },
    ["@markup.heading.3.marker.markdown"] = { link = "markdownH3Delimiter" },
    ["@markup.heading.4.marker.markdown"] = { link = "markdownH4Delimiter" },
    ["@markup.heading.5.marker.markdown"] = { link = "markdownH5Delimiter" },
    ["@markup.heading.6.marker.markdown"] = { link = "markdownH6Delimiter" },

    ["@diff.plus"] = { fg = g.git_add, bg = g.git_add, blend = 20 },
    ["@diff.minus"] = { fg = g.git_delete, bg = g.git_delete, blend = 20 },
    ["@diff.delta"] = { bg = g.git_change, blend = 20 },

    ["@tag"] = { link = "Tag" },
    ["@tag.attribute"] = { fg = p.iris },
    ["@tag.delimiter"] = { fg = p.subtle },

    --- Non-highlighting captures
    -- ["@none"] = {},
    ["@conceal"] = { link = "Conceal" },
    ["@conceal.markdown"] = { fg = p.subtle },

    -- ["@spell"] = {},
    -- ["@nospell"] = {},

    --- Semantic
    ["@lsp.type.comment"] = {},
    ["@lsp.type.comment.c"] = { link = "@comment" },
    ["@lsp.type.comment.cpp"] = { link = "@comment" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.interface"] = { link = "@interface" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.namespace.python"] = { link = "@variable" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.variable"] = {}, -- defer to treesitter for regular variables
    ["@lsp.type.variable.svelte"] = { link = "@variable" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.variable.constant"] = { link = "@constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },

    --- Plugins
    -- romgrk/barbar.nvim
    BufferCurrent = { fg = p.text, bg = p.overlay },
    BufferCurrentIndex = { fg = p.text, bg = p.overlay },
    BufferCurrentMod = { fg = p.foam, bg = p.overlay },
    BufferCurrentSign = { fg = p.subtle, bg = p.overlay },
    BufferCurrentTarget = { fg = p.gold, bg = p.overlay },
    BufferInactive = { fg = p.subtle },
    BufferInactiveIndex = { fg = p.subtle },
    BufferInactiveMod = { fg = p.foam },
    BufferInactiveSign = { fg = p.muted },
    BufferInactiveTarget = { fg = p.gold },
    BufferTabpageFill = { fg = "NONE", bg = "NONE" },
    BufferVisible = { fg = p.subtle },
    BufferVisibleIndex = { fg = p.subtle },
    BufferVisibleMod = { fg = p.foam },
    BufferVisibleSign = { fg = p.muted },
    BufferVisibleTarget = { fg = p.gold },

    -- lewis6991/gitsigns.nvim
    GitSignsAdd = { fg = g.git_add, bg = "NONE" },
    GitSignsChange = { fg = g.git_change, bg = "NONE" },
    GitSignsDelete = { fg = g.git_delete, bg = "NONE" },
    SignAdd = { fg = g.git_add, bg = "NONE" },
    SignChange = { fg = g.git_change, bg = "NONE" },
    SignDelete = { fg = g.git_delete, bg = "NONE" },

    -- mvllow/modes.nvim
    ModesCopy = { bg = p.gold },
    ModesDelete = { bg = p.love },
    ModesFormat = { bg = p.rose },
    ModesInsert = { bg = p.foam },
    ModesReplace = { bg = p.pine },
    ModesVisual = { bg = p.iris },

    -- kyazdani42/nvim-tree.lua
    NvimTreeEmptyFolderName = { fg = p.muted },
    NvimTreeFileDeleted = { fg = g.git_delete },
    NvimTreeFileDirty = { fg = g.git_dirty },
    NvimTreeFileMerge = { fg = g.git_merge },
    NvimTreeFileNew = { fg = p.foam },
    NvimTreeFileRenamed = { fg = g.git_rename },
    NvimTreeFileStaged = { fg = g.git_stage },
    NvimTreeFolderIcon = { fg = p.subtle },
    NvimTreeFolderName = { fg = p.foam },
    NvimTreeGitDeleted = { fg = g.git_delete },
    NvimTreeGitDirty = { fg = g.git_dirty },
    NvimTreeGitIgnored = { fg = g.git_ignore },
    NvimTreeGitMerge = { fg = g.git_merge },
    NvimTreeGitNew = { fg = g.git_add },
    NvimTreeGitRenamed = { fg = g.git_rename },
    NvimTreeGitStaged = { fg = g.git_stage },
    NvimTreeImageFile = { fg = p.text },
    NvimTreeNormal = { link = "Normal" },
    NvimTreeOpenedFile = { fg = p.text, bg = p.overlay },
    NvimTreeOpenedFolderName = { link = "NvimTreeFolderName" },
    NvimTreeRootFolder = { fg = p.foam, bold = bold },
    NvimTreeSpecialFile = { link = "NvimTreeNormal" },
    NvimTreeWindowPicker = { link = "StatusLineTerm" },

    -- nvim-neotest/neotest
    NeotestAdapterName = { fg = p.iris },
    NeotestBorder = { fg = p.highlight_med },
    NeotestDir = { fg = p.foam },
    NeotestExpandMarker = { fg = p.highlight_med },
    NeotestFailed = { fg = p.love },
    NeotestFile = { fg = p.text },
    NeotestFocused = { fg = p.gold, bg = p.highlight_med },
    NeotestIndent = { fg = p.highlight_med },
    NeotestMarked = { fg = p.rose, bold = bold },
    NeotestNamespace = { fg = p.gold },
    NeotestPassed = { fg = p.pine },
    NeotestRunning = { fg = p.gold },
    NeotestWinSelect = { fg = p.muted },
    NeotestSkipped = { fg = p.subtle },
    NeotestTarget = { fg = p.love },
    NeotestTest = { fg = p.gold },
    NeotestUnknown = { fg = p.subtle },
    NeotestWatching = { fg = p.iris },

    -- nvim-neo-tree/neo-tree.nvim
    NeoTreeGitAdded = { fg = g.git_add },
    NeoTreeGitConflict = { fg = g.git_merge },
    NeoTreeGitDeleted = { fg = g.git_delete },
    NeoTreeGitIgnored = { fg = g.git_ignore },
    NeoTreeGitModified = { fg = g.git_dirty },
    NeoTreeGitRenamed = { fg = g.git_rename },
    NeoTreeGitUntracked = { fg = g.git_untracked },
    NeoTreeTabActive = { fg = p.text, bg = p.overlay },
    NeoTreeTabInactive = { fg = p.subtle },
    NeoTreeTabSeparatorActive = { link = "WinSeparator" },
    NeoTreeTabSeparatorInactive = { link = "WinSeparator" },
    NeoTreeTitleBar = { link = "StatusLineTerm" },

    -- folke/flash.nvim
    FlashLabel = { fg = p.base, bg = p.love },

    -- folke/which-key.nvim
    WhichKey = { fg = p.iris },
    WhichKeyBorder = make_border(),
    WhichKeyDesc = { fg = p.gold },
    WhichKeyFloat = { bg = g.panel },
    WhichKeyGroup = { fg = p.foam },
    WhichKeyIcon = { fg = p.pine },
    WhichKeyIconAzure = { fg = p.pine },
    WhichKeyIconBlue = { fg = p.pine },
    WhichKeyIconCyan = { fg = p.foam },
    WhichKeyIconGreen = { fg = p.leaf },
    WhichKeyIconGrey = { fg = p.subtle },
    WhichKeyIconOrange = { fg = p.rose },
    WhichKeyIconPurple = { fg = p.iris },
    WhichKeyIconRed = { fg = p.love },
    WhichKeyIconYellow = { fg = p.gold },
    WhichKeyNormal = { link = "NormalFloat" },
    WhichKeySeparator = { fg = p.subtle },
    WhichKeyTitle = { link = "FloatTitle" },
    WhichKeyValue = { fg = p.rose },

    -- lukas-reineke/indent-blankline.nvim
    IblIndent = { fg = p.overlay },
    IblScope = { fg = p.foam },
    IblWhitespace = { fg = p.overlay },

    -- hrsh7th/nvim-cmp
    CmpItemAbbr = { fg = p.subtle },
    CmpItemAbbrDeprecated = { fg = p.subtle, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.text, bold = bold },
    CmpItemAbbrMatchFuzzy = { fg = p.text, bold = bold },
    CmpItemKind = { fg = p.subtle },
    CmpItemKindClass = { link = "StorageClass" },
    CmpItemKindFunction = { link = "Function" },
    CmpItemKindInterface = { link = "Type" },
    CmpItemKindMethod = { link = "PreProc" },
    CmpItemKindSnippet = { link = "String" },
    CmpItemKindVariable = { link = "Identifier" },

    -- NeogitOrg/neogit
    -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
    NeogitChangeAdded = { fg = g.git_add, bold = bold, italic = italic },
    NeogitChangeBothModified = { fg = g.git_change, bold = bold, italic = italic },
    NeogitChangeCopied = { fg = g.git_untracked, bold = bold, italic = italic },
    NeogitChangeDeleted = { fg = g.git_delete, bold = bold, italic = italic },
    NeogitChangeModified = { fg = g.git_change, bold = bold, italic = italic },
    NeogitChangeNewFile = { fg = g.git_stage, bold = bold, italic = italic },
    NeogitChangeRenamed = { fg = g.git_rename, bold = bold, italic = italic },
    NeogitChangeUpdated = { fg = g.git_change, bold = bold, italic = italic },
    NeogitDiffAddHighlight = { link = "DiffAdd" },
    NeogitDiffContextHighlight = { bg = p.surface },
    NeogitDiffDeleteHighlight = { link = "DiffDelete" },
    NeogitFilePath = { fg = p.foam, italic = italic },
    NeogitHunkHeader = { bg = g.panel },
    NeogitHunkHeaderHighlight = { bg = g.panel },

    -- vimwiki/vimwiki
    VimwikiHR = { fg = p.subtle },
    VimwikiHeader1 = { link = "markdownH1" },
    VimwikiHeader2 = { link = "markdownH2" },
    VimwikiHeader3 = { link = "markdownH3" },
    VimwikiHeader4 = { link = "markdownH4" },
    VimwikiHeader5 = { link = "markdownH5" },
    VimwikiHeader6 = { link = "markdownH6" },
    VimwikiHeaderChar = { fg = p.subtle },
    VimwikiLink = { link = "markdownUrl" },
    VimwikiList = { fg = p.iris },
    VimwikiNoExistsLink = { fg = p.love },

    -- nvim-neorg/neorg
    NeorgHeading1Prefix = { link = "markdownH1Delimiter" },
    NeorgHeading1Title = { link = "markdownH1" },
    NeorgHeading2Prefix = { link = "markdownH2Delimiter" },
    NeorgHeading2Title = { link = "markdownH2" },
    NeorgHeading3Prefix = { link = "markdownH3Delimiter" },
    NeorgHeading3Title = { link = "markdownH3" },
    NeorgHeading4Prefix = { link = "markdownH4Delimiter" },
    NeorgHeading4Title = { link = "markdownH4" },
    NeorgHeading5Prefix = { link = "markdownH5Delimiter" },
    NeorgHeading5Title = { link = "markdownH5" },
    NeorgHeading6Prefix = { link = "markdownH6Delimiter" },
    NeorgHeading6Title = { link = "markdownH6" },
    NeorgMarkerTitle = { fg = p.foam, bold = bold },

    -- tami5/lspsaga.nvim (fork of glepnir/lspsaga.nvim)
    DefinitionCount = { fg = p.rose },
    DefinitionIcon = { fg = p.rose },
    DefinitionPreviewTitle = { fg = p.rose, bold = bold },
    LspFloatWinBorder = make_border(),
    LspFloatWinNormal = { bg = g.panel },
    LspSagaAutoPreview = { fg = p.subtle },
    LspSagaCodeActionBorder = make_border(p.rose),
    LspSagaCodeActionContent = { fg = p.foam },
    LspSagaCodeActionTitle = { fg = p.gold, bold = bold },
    LspSagaCodeActionTruncateLine = { link = "LspSagaCodeActionBorder" },
    LspSagaDefPreviewBorder = make_border(),
    LspSagaDiagnosticBorder = make_border(p.gold),
    LspSagaDiagnosticHeader = { fg = p.foam, bold = bold },
    LspSagaDiagnosticTruncateLine = { link = "LspSagaDiagnosticBorder" },
    LspSagaDocTruncateLine = { link = "LspSagaHoverBorder" },
    LspSagaFinderSelection = { fg = p.gold },
    LspSagaHoverBorder = { link = "LspFloatWinBorder" },
    LspSagaLspFinderBorder = { link = "LspFloatWinBorder" },
    LspSagaRenameBorder = make_border(p.pine),
    LspSagaRenamePromptPrefix = { fg = p.love },
    LspSagaShTruncateLine = { link = "LspSagaSignatureHelpBorder" },
    LspSagaSignatureHelpBorder = make_border(p.foam),
    ReferencesCount = { fg = p.rose },
    ReferencesIcon = { fg = p.rose },
    SagaShadow = { bg = p.overlay },
    TargetWord = { fg = p.iris },

    -- ray-x/lsp_signature.nvim
    LspSignatureActiveParameter = { bg = p.overlay },

    -- rlane/pounce.nvim
    PounceAccept = { fg = p.love, bg = p.love, blend = 20 },
    PounceAcceptBest = { fg = p.gold, bg = p.gold, blend = 20 },
    PounceGap = { link = "Search" },
    PounceMatch = { link = "Search" },

    -- ggandor/leap.nvim
    LeapLabelPrimary = { link = "IncSearch" },
    LeapLabelSecondary = { link = "StatusLineTerm" },
    LeapMatch = { link = "MatchParen" },

    -- phaazon/hop.nvim
    -- smoka7/hop.nvim
    HopNextKey = { fg = p.love, bg = p.love, blend = 20 },
    HopNextKey1 = { fg = p.foam, bg = p.foam, blend = 20 },
    HopNextKey2 = { fg = p.pine, bg = p.pine, blend = 20 },
    HopUnmatched = { fg = p.muted },

    -- nvim-telescope/telescope.nvim
    TelescopeBorder = make_border(),
    TelescopeMatching = { fg = p.rose },
    TelescopeNormal = { link = "NormalFloat" },
    TelescopePromptNormal = { link = "TelescopeNormal" },
    TelescopePromptPrefix = { fg = p.subtle },
    TelescopeSelection = { fg = p.text, bg = p.overlay },
    TelescopeSelectionCaret = { fg = p.rose, bg = p.overlay },
    TelescopeTitle = { fg = p.foam, bold = bold },

    -- ibhagwan/fzf-lua
    FzfLuaBorder = make_border(),
    FzfLuaBufFlagAlt = { fg = p.subtle },
    FzfLuaBufFlagCur = { fg = p.subtle },
    FzfLuaCursorLine = { fg = p.text, bg = p.overlay },
    FzfLuaFilePart = { fg = p.text },
    FzfLuaHeaderBind = { fg = p.rose },
    FzfLuaHeaderText = { fg = p.love },
    FzfLuaNormal = { link = "NormalFloat" },
    FzfLuaTitle = { link = "FloatTitle" },

    -- rcarriga/nvim-notify
    NotifyBackground = { link = "NormalFloat" },
    NotifyDEBUGBody = { link = "NormalFloat" },
    NotifyDEBUGBorder = make_border(),
    NotifyDEBUGIcon = { link = "NotifyDEBUGTitle" },
    NotifyDEBUGTitle = { fg = p.muted },
    NotifyERRORBody = { link = "NormalFloat" },
    NotifyERRORBorder = make_border(g.error),
    NotifyERRORIcon = { link = "NotifyERRORTitle" },
    NotifyERRORTitle = { fg = g.error },
    NotifyINFOBody = { link = "NormalFloat" },
    NotifyINFOBorder = make_border(g.info),
    NotifyINFOIcon = { link = "NotifyINFOTitle" },
    NotifyINFOTitle = { fg = g.info },
    NotifyTRACEBody = { link = "NormalFloat" },
    NotifyTRACEBorder = make_border(p.iris),
    NotifyTRACEIcon = { link = "NotifyTRACETitle" },
    NotifyTRACETitle = { fg = p.iris },
    NotifyWARNBody = { link = "NormalFloat" },
    NotifyWARNBorder = make_border(g.warn),
    NotifyWARNIcon = { link = "NotifyWARNTitle" },
    NotifyWARNTitle = { fg = g.warn },

    -- rcarriga/nvim-dap-ui
    DapUIBreakpointsCurrentLine = { fg = p.gold, bold = bold },
    DapUIBreakpointsDisabledLine = { fg = p.muted },
    DapUIBreakpointsInfo = { link = "DapUIThread" },
    DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
    DapUIBreakpointsPath = { fg = p.foam },
    DapUIDecoration = { link = "DapUIBreakpointsPath" },
    DapUIFloatBorder = make_border(),
    DapUIFrameName = { fg = p.text },
    DapUILineNumber = { link = "DapUIBreakpointsPath" },
    DapUIModifiedValue = { fg = p.foam, bold = bold },
    DapUIScope = { link = "DapUIBreakpointsPath" },
    DapUISource = { fg = p.iris },
    DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
    DapUIThread = { fg = p.gold },
    DapUIValue = { fg = p.text },
    DapUIVariable = { fg = p.text },
    DapUIType = { fg = p.iris },
    DapUIWatchesEmpty = { fg = p.love },
    DapUIWatchesError = { link = "DapUIWatchesEmpty" },
    DapUIWatchesValue = { link = "DapUIThread" },

    -- glepnir/dashboard-nvim
    DashboardCenter = { fg = p.gold },
    DashboardFooter = { fg = p.iris },
    DashboardHeader = { fg = p.pine },
    DashboardShortcut = { fg = p.love },

    -- SmiteshP/nvim-navic
    NavicIconsArray = { fg = p.gold },
    NavicIconsBoolean = { fg = p.rose },
    NavicIconsClass = { fg = p.foam },
    NavicIconsConstant = { fg = p.gold },
    NavicIconsConstructor = { fg = p.gold },
    NavicIconsEnum = { fg = p.gold },
    NavicIconsEnumMember = { fg = p.foam },
    NavicIconsEvent = { fg = p.gold },
    NavicIconsField = { fg = p.foam },
    NavicIconsFile = { fg = p.muted },
    NavicIconsFunction = { fg = p.pine },
    NavicIconsInterface = { fg = p.foam },
    NavicIconsKey = { fg = p.iris },
    NavicIconsKeyword = { fg = p.pine },
    NavicIconsMethod = { fg = p.iris },
    NavicIconsModule = { fg = p.rose },
    NavicIconsNamespace = { fg = p.muted },
    NavicIconsNull = { fg = p.love },
    NavicIconsNumber = { fg = p.gold },
    NavicIconsObject = { fg = p.gold },
    NavicIconsOperator = { fg = p.subtle },
    NavicIconsPackage = { fg = p.muted },
    NavicIconsProperty = { fg = p.foam },
    NavicIconsString = { fg = p.gold },
    NavicIconsStruct = { fg = p.foam },
    NavicIconsTypeParameter = { fg = p.foam },
    NavicIconsVariable = { fg = p.text },
    NavicSeparator = { fg = p.subtle },
    NavicText = { fg = p.subtle },

    -- folke/noice.nvim
    NoiceCursor = { fg = p.highlight_high, bg = p.text },

    -- folke/trouble.nvim
    TroubleText = { fg = p.subtle },
    TroubleCount = { fg = p.iris, bg = p.surface },
    TroubleNormal = { fg = p.text, bg = g.panel },

    -- echasnovski/mini.nvim
    MiniAnimateCursor = { reverse = true, nocombine = true },
    MiniAnimateNormalFloat = { link = "NormalFloat" },

    MiniClueBorder = { link = "FloatBorder" },
    MiniClueDescGroup = { link = "DiagnosticFloatingWarn" },
    MiniClueDescSingle = { link = "NormalFloat" },
    MiniClueNextKey = { link = "DiagnosticFloatingHint" },
    MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
    MiniClueSeparator = { link = "DiagnosticFloatingInfo" },
    MiniClueTitle = { bg = g.panel, bold = bold },

    MiniCompletionActiveParameter = { underline = true },

    MiniCursorword = { underline = true },
    MiniCursorwordCurrent = { underline = true },

    MiniDepsChangeAdded = { fg = g.git_add },
    MiniDepsChangeRemoved = { fg = g.git_delete },
    MiniDepsHint = { link = "DiagnosticHint" },
    MiniDepsInfo = { link = "DiagnosticInfo" },
    MiniDepsMsgBreaking = { link = "DiagnosticWarn" },
    MiniDepsPlaceholder = { link = "Comment" },
    MiniDepsTitle = { link = "Title" },
    MiniDepsTitleError = { link = "DiffDelete" },
    MiniDepsTitleSame = { link = "DiffText" },
    MiniDepsTitleUpdate = { link = "DiffAdd" },

    MiniDiffOverAdd = { fg = g.git_add, bg = g.git_add, blend = 20 },
    MiniDiffOverChange = { fg = g.git_change, bg = g.git_change, blend = 20 },
    MiniDiffOverContext = { bg = p.surface },
    MiniDiffOverDelete = { fg = g.git_delete, bg = g.git_delete, blend = 20 },
    MiniDiffSignAdd = { fg = g.git_add },
    MiniDiffSignChange = { fg = g.git_change },
    MiniDiffSignDelete = { fg = g.git_delete },

    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
    MiniFilesCursorLine = { link = "CursorLine" },
    MiniFilesDirectory = { link = "Directory" },
    MiniFilesFile = { fg = p.text },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesTitle = { link = "FloatTitle" },
    MiniFilesTitleFocused = { fg = p.rose, bg = g.panel, bold = bold },

    MiniHipatternsFixme = { fg = p.base, bg = g.error, bold = bold },
    MiniHipatternsHack = { fg = p.base, bg = g.warn, bold = bold },
    MiniHipatternsNote = { fg = p.base, bg = g.info, bold = bold },
    MiniHipatternsTodo = { fg = p.base, bg = g.hint, bold = bold },

    MiniIconsAzure = { fg = p.foam },
    MiniIconsBlue = { fg = p.pine },
    MiniIconsCyan = { fg = p.foam },
    MiniIconsGreen = { fg = p.leaf },
    MiniIconsGrey = { fg = p.subtle },
    MiniIconsOrange = { fg = p.rose },
    MiniIconsPurple = { fg = p.iris },
    MiniIconsRed = { fg = p.love },
    MiniIconsYellow = { fg = p.gold },

    MiniIndentscopeSymbol = { fg = p.muted },
    MiniIndentscopeSymbolOff = { fg = p.gold },

    MiniJump = { sp = p.gold, undercurl = true },

    MiniJump2dDim = { fg = p.subtle },
    MiniJump2dSpot = { fg = p.gold, bold = bold, nocombine = true },
    MiniJump2dSpotAhead = { fg = p.foam, bg = p.surface, nocombine = true },
    MiniJump2dSpotUnique = { fg = p.rose, bold = bold, nocombine = true },

    MiniMapNormal = { link = "NormalFloat" },
    MiniMapSymbolCount = { link = "Special" },
    MiniMapSymbolLine = { link = "Title" },
    MiniMapSymbolView = { link = "Delimiter" },

    MiniNotifyBorder = { link = "FloatBorder" },
    MiniNotifyNormal = { link = "NormalFloat" },
    MiniNotifyTitle = { link = "FloatTitle" },

    MiniOperatorsExchangeFrom = { link = "IncSearch" },

    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderBusy = { link = "DiagnosticFloatingWarn" },
    MiniPickBorderText = { bg = g.panel },
    MiniPickIconDirectory = { link = "Directory" },
    MiniPickIconFile = { link = "MiniPickNormal" },
    MiniPickHeader = { link = "DiagnosticFloatingHint" },
    MiniPickMatchCurrent = { link = "CursorLine" },
    MiniPickMatchMarked = { link = "Visual" },
    MiniPickMatchRanges = { fg = p.foam },
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickPreviewLine = { link = "CursorLine" },
    MiniPickPreviewRegion = { link = "IncSearch" },
    MiniPickPrompt = { bg = g.panel, bold = bold },

    MiniStarterCurrent = { nocombine = true },
    MiniStarterFooter = { fg = p.subtle },
    MiniStarterHeader = { link = "Title" },
    MiniStarterInactive = { link = "Comment" },
    MiniStarterItem = { link = "Normal" },
    MiniStarterItemBullet = { link = "Delimiter" },
    MiniStarterItemPrefix = { link = "WarningMsg" },
    MiniStarterSection = { fg = p.rose },
    MiniStarterQuery = { link = "MoreMsg" },

    MiniStatuslineDevinfo = { fg = p.subtle, bg = p.overlay },
    MiniStatuslineFileinfo = { link = "MiniStatuslineDevinfo" },
    MiniStatuslineFilename = { fg = p.muted, bg = p.surface },
    MiniStatuslineInactive = { link = "MiniStatuslineFilename" },
    MiniStatuslineModeCommand = { fg = p.base, bg = p.love, bold = bold },
    MiniStatuslineModeInsert = { fg = p.base, bg = p.foam, bold = bold },
    MiniStatuslineModeNormal = { fg = p.base, bg = p.rose, bold = bold },
    MiniStatuslineModeOther = { fg = p.base, bg = p.rose, bold = bold },
    MiniStatuslineModeReplace = { fg = p.base, bg = p.pine, bold = bold },
    MiniStatuslineModeVisual = { fg = p.base, bg = p.iris, bold = bold },

    MiniSurround = { link = "IncSearch" },

    MiniTablineCurrent = { fg = p.text, bg = p.overlay, bold = bold },
    MiniTablineFill = { link = "TabLineFill" },
    MiniTablineHidden = { fg = p.subtle, bg = g.panel },
    MiniTablineModifiedCurrent = { fg = p.overlay, bg = p.text, bold = bold },
    MiniTablineModifiedHidden = { fg = g.panel, bg = p.subtle },
    MiniTablineModifiedVisible = { fg = g.panel, bg = p.text },
    MiniTablineTabpagesection = { link = "Search" },
    MiniTablineVisible = { fg = p.text, bg = g.panel },

    MiniTestEmphasis = { bold = bold },
    MiniTestFail = { fg = p.love, bold = bold },
    MiniTestPass = { fg = p.foam, bold = bold },

    MiniTrailspace = { bg = p.love },

    -- goolord/alpha-nvim
    AlphaButtons = { fg = p.foam },
    AlphaFooter = { fg = p.gold },
    AlphaHeader = { fg = p.pine },
    AlphaShortcut = { fg = p.rose },

    -- github/copilot.vim
    CopilotSuggestion = { fg = p.muted, italic = italic },

    -- nvim-treesitter/nvim-treesitter-context
    TreesitterContext = { bg = p.overlay },
    TreesitterContextLineNumber = { fg = p.rose, bg = p.overlay },

    -- RRethy/vim-illuminate
    IlluminatedWordRead = { link = "LspReferenceRead" },
    IlluminatedWordText = { link = "LspReferenceText" },
    IlluminatedWordWrite = { link = "LspReferenceWrite" },

    -- HiPhish/rainbow-delimiters.nvim
    RainbowDelimiterBlue = { fg = p.pine },
    RainbowDelimiterCyan = { fg = p.foam },
    RainbowDelimiterGreen = { fg = p.leaf },
    RainbowDelimiterOrange = { fg = p.rose },
    RainbowDelimiterRed = { fg = p.love },
    RainbowDelimiterViolet = { fg = p.iris },
    RainbowDelimiterYellow = { fg = p.gold },

    -- MeanderingProgrammer/render-markdown.nvim
    RenderMarkdownBullet = { fg = p.rose },
    RenderMarkdownChecked = { fg = p.foam },
    RenderMarkdownCode = { bg = p.overlay },
    RenderMarkdownCodeInline = { fg = p.text, bg = p.overlay },
    RenderMarkdownDash = { fg = p.muted },
    RenderMarkdownH1Bg = { bg = g.h1, blend = 20 },
    RenderMarkdownH2Bg = { bg = g.h2, blend = 20 },
    RenderMarkdownH3Bg = { bg = g.h3, blend = 20 },
    RenderMarkdownH4Bg = { bg = g.h4, blend = 20 },
    RenderMarkdownH5Bg = { bg = g.h5, blend = 20 },
    RenderMarkdownH6Bg = { bg = g.h6, blend = 20 },
    RenderMarkdownQuote = { fg = p.subtle },
    RenderMarkdownTableFill = { link = "Conceal" },
    RenderMarkdownTableHead = { fg = p.subtle },
    RenderMarkdownTableRow = { fg = p.subtle },
    RenderMarkdownUnchecked = { fg = p.subtle },

    -- MagicDuck/grug-far.nvim
    GrugFarHelpHeader = { fg = p.pine },
    GrugFarHelpHeaderKey = { fg = p.gold },
    GrugFarHelpWinActionKey = { fg = p.gold },
    GrugFarHelpWinActionPrefix = { fg = p.foam },
    GrugFarHelpWinActionText = { fg = p.pine },
    GrugFarHelpWinHeader = { link = "FloatTitle" },
    GrugFarInputLabel = { fg = p.foam },
    GrugFarInputPlaceholder = { link = "Comment" },
    GrugFarResultsActionMessage = { fg = p.foam },
    GrugFarResultsChangeIndicator = { fg = g.git_change },
    GrugFarResultsRemoveIndicator = { fg = g.git_delete },
    GrugFarResultsAddIndicator = { fg = g.git_add },
    GrugFarResultsHeader = { fg = p.pine },
    GrugFarResultsLineNo = { fg = p.iris },
    GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" },
    GrugFarResultsMatch = { link = "CurSearch" },
    GrugFarResultsPath = { fg = p.foam },
    GrugFarResultsStats = { fg = p.iris },

    -- yetone/avante.nvim
    AvanteTitle = { fg = p.highlight_high, bg = p.rose },
    AvanteReversedTitle = { fg = p.rose },
    AvanteSubtitle = { fg = p.highlight_med, bg = p.foam },
    AvanteReversedSubtitle = { fg = p.foam },
    AvanteThirdTitle = { fg = p.highlight_med, bg = p.iris },
    AvanteReversedThirdTitle = { fg = p.iris },
    AvantePromptInput = { fg = p.text, bg = g.panel },
    AvantePromptInputBorder = { fg = g.border },

    -- Saghen/blink.cmp
    BlinkCmpDoc = { bg = p.highlight_low },
    BlinkCmpDocSeparator = { bg = p.highlight_low },
    BlinkCmpDocBorder = { fg = p.highlight_high },
    BlinkCmpGhostText = { fg = p.muted },

    BlinkCmpLabel = { fg = p.muted },
    BlinkCmpLabelDeprecated = { fg = p.muted, strikethrough = true },
    BlinkCmpLabelMatch = { fg = p.text, bold = bold },

    BlinkCmpDefault = { fg = p.highlight_med },
    BlinkCmpKindText = { fg = p.pine },
    BlinkCmpKindMethod = { fg = p.foam },
    BlinkCmpKindFunction = { fg = p.foam },
    BlinkCmpKindConstructor = { fg = p.foam },
    BlinkCmpKindField = { fg = p.pine },
    BlinkCmpKindVariable = { fg = p.rose },
    BlinkCmpKindClass = { fg = p.gold },
    BlinkCmpKindInterface = { fg = p.gold },
    BlinkCmpKindModule = { fg = p.foam },
    BlinkCmpKindProperty = { fg = p.foam },
    BlinkCmpKindUnit = { fg = p.pine },
    BlinkCmpKindValue = { fg = p.love },
    BlinkCmpKindKeyword = { fg = p.iris },
    BlinkCmpKindSnippet = { fg = p.rose },
    BlinkCmpKindColor = { fg = p.love },
    BlinkCmpKindFile = { fg = p.foam },
    BlinkCmpKindReference = { fg = p.love },
    BlinkCmpKindFolder = { fg = p.foam },
    BlinkCmpKindEnum = { fg = p.foam },
    BlinkCmpKindEnumMember = { fg = p.foam },
    BlinkCmpKindConstant = { fg = p.gold },
    BlinkCmpKindStruct = { fg = p.foam },
    BlinkCmpKindEvent = { fg = p.foam },
    BlinkCmpKindOperator = { fg = p.foam },
    BlinkCmpKindTypeParameter = { fg = p.iris },
    BlinkCmpKindCodeium = { fg = p.foam },
    BlinkCmpKindCopilot = { fg = p.foam },
    BlinkCmpKindSupermaven = { fg = p.foam },
    BlinkCmpKindTabNine = { fg = p.foam },

    -- folke/snacks.nvim
    SnacksIndent = { fg = p.overlay },
    SnacksIndentChunk = { fg = p.overlay },
    SnacksIndentBlank = { fg = p.overlay },
    SnacksIndentScope = { fg = p.foam },

    SnacksPickerMatch = { fg = p.rose, bold = bold },

    -- justinmk/vim-sneak
    Sneak = { fg = p.base, bg = p.love },
    SneakCurrent = { link = "StatusLineTerm" },
    SneakScope = { link = "IncSearch" },

    -- sindrets/diffview.nvim
    DiffviewPrimary = { fg = p.pine },
    DiffviewSecondary = { fg = p.foam },
    DiffviewNormal = { fg = p.text, bg = p.surface },
    DiffviewWinSeparator = { fg = p.text, bg = p.surface },

    DiffviewFilePanelTitle = { fg = p.foam, bold = bold },
    DiffviewFilePanelCounter = { fg = p.rose },
    DiffviewFilePanelRootPath = { fg = p.foam, bold = bold },
    DiffviewFilePanelFileName = { fg = p.text },
    DiffviewFilePanelSelected = { fg = p.gold },
    DiffviewFilePanelPath = { link = "Comment" },

    DiffviewFilePanelInsertions = { fg = g.git_add },
    DiffviewFilePanelDeletions = { fg = g.git_delete },
    DiffviewFilePanelConflicts = { fg = g.git_merge },
    DiffviewFolderName = { fg = p.foam, bold = bold },
    DiffviewFolderSign = { fg = p.subtle },
    DiffviewHash = { fg = p.rose },
    DiffviewReference = { fg = p.foam, bold = bold },
    DiffviewReflogSelector = { fg = p.rose },
    DiffviewStatusAdded = { fg = g.git_add },
    DiffviewStatusUntracked = { fg = g.git_untracked },
    DiffviewStatusModified = { fg = g.git_change },
    DiffviewStatusRenamed = { fg = g.git_rename },
    DiffviewStatusCopied = { fg = g.git_untracked },
    DiffviewStatusTypeChange = { fg = g.git_change },
    DiffviewStatusUnmerged = { fg = g.git_change },
    DiffviewStatusUnknown = { fg = g.git_delete },
    DiffviewStatusDeleted = { fg = g.git_delete },
    DiffviewStatusBroken = { fg = g.git_delete },
    DiffviewStatusIgnored = { fg = g.git_ignore },
  }

  local highlights = {}
  for group, spec in pairs(legacy) do
    highlights[group] = spec
  end
  for group, spec in pairs(default) do
    highlights[group] = spec
  end

  -- `nvim_set_hl`'s own `blend` only applies to floating windows, so resolve
  -- the mark into a flat `bg` the way upstream does.
  for _, spec in pairs(highlights) do
    if spec.blend ~= nil and spec.blend >= 0 and spec.blend <= 100 and spec.bg ~= nil then
      spec.bg = blend(spec.bg, p.base, spec.blend / 100)
    end
    spec.blend = nil
  end

  return highlights
end

---Terminal colours 0 to 15, in order.
---@param variant RosePineVariant
---@return string[]
function M.terminal(variant)
  local p = assert(palettes[variant], "unknown rose-pine variant: " .. tostring(variant))
  return {
    p.overlay, -- 0 black
    p.love, -- 1 red
    p.pine, -- 2 green
    p.gold, -- 3 yellow
    p.foam, -- 4 blue
    p.iris, -- 5 magenta
    p.rose, -- 6 cyan
    p.text, -- 7 white
    p.subtle, -- 8 bright black
    p.love, -- 9 bright red
    p.pine, -- 10 bright green
    p.gold, -- 11 bright yellow
    p.foam, -- 12 bright blue
    p.iris, -- 13 bright magenta
    p.rose, -- 14 bright cyan
    p.text, -- 15 bright white
  }
end

---Mirror upstream's terminal support for vim's `StatusLineTerm` groups.
---The autocmd removes itself when the next colorscheme loads.
function M.setup()
  vim.cmd [[
  augroup zenobius-themes-rose-pine
    autocmd!
    autocmd TermOpen * if &buftype=='terminal'
      \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
      \|else|setlocal winhighlight=|endif
    autocmd ColorSchemePre * autocmd! zenobius-themes-rose-pine
  augroup END
  ]]
end

return M
