-- Plugin: graphql.nvim
-- Description: GraphQL syntax highlighting and language support (Apollo compatible)
-- URL: https://www.apollographql.com/docs/ide-support/vim
---@type LazySpec
return {
  -- File type detection for .graphql and .gql files
  {
    "AstroNvim/astrocore",
    opts = {
      filetypes = {
        extension = {
          graphql = "graphql",
          gql = "graphql",
        },
      },
    },
  },
}
