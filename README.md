# Package.swift LSP for Neovim

Neovim LSP client for [package-swift-lsp](https://github.com/kattouf/package-swift-lsp) - provides smart completions for Swift Package Manager's `Package.swift` manifest files.

![demo](https://github.com/user-attachments/assets/017d4aea-8b16-49d1-b818-6386b9d9b066)

## Features

- **Smart code completions in `Package.swift` files:**
  - **`.package(...)` function:**
    - GitHub repository suggestions for `url:` parameter
    - Version suggestions for `from:` and `exact:` parameters
    - Branch name suggestions for `branch:` parameter
  - **`.product(...)` function:**
    - Product name suggestions from package dependencies
    - Package name suggestions
  - **`.target(...)` function:**
    - Local target name suggestions from the package
  - **Target dependencies string literals:**
    - Automatic product name expansion from dependencies
    - Local target name referencing
- **Contextual hover information:**
  - Package details (location and state)
  - Available products in packages

## Requirements

- Neovim 0.8+
- `nvim-lspconfig` plugin
- `package-swift-lsp` binary ([install from releases](https://github.com/kattouf/package-swift-lsp/releases))

> **Note:** After editing package dependencies (`.package(...)`), save the file for changes to be reflected in target completions.

## Installation

### 1. Install package-swift-lsp binary

Download the latest release from [GitHub releases](https://github.com/kattouf/package-swift-lsp/releases) and ensure it's in your PATH.

### 2. Install this plugin

**With [lazy.nvim](https://github.com/folke/lazy.nvim):**
```lua
{
  'kattouf/package-swift-lsp-neovim',
  ft = 'swift',
  config = function()
    require('package-swift-lsp').setup()
  end,
}
```

**With [packer.nvim](https://github.com/wbthomason/packer.nvim):**
```lua
use {
  'kattouf/package-swift-lsp-neovim',
  ft = 'swift',
  config = function()
    require('package-swift-lsp').setup()
  end,
  requires = 'neovim/nvim-lspconfig'
}
```

**Manual installation:**
```bash
git clone https://github.com/kattouf/package-swift-lsp-neovim ~/.config/nvim/pack/plugins/start/package-swift-lsp-neovim
```

## Configuration

### Basic Setup

Set up LSP server in your `init.lua`:

```lua
-- Setup package-swift-lsp for Package.swift completions
require('package-swift-lsp').setup({
  -- Configuration options (all optional)
})
```

### Configuration Options

```lua
require('package-swift-lsp').setup({
  -- Custom binary path (if not in PATH)
  cmd = { '/path/to/package-swift-lsp' },
})
```

## Commands

- `:PackageSwiftLSPLogs` - Open LSP log file for debugging
- `:PackageSwiftLSPRestart` - Restart the package-swift-lsp server
- `:LspInfo` - Show all active LSP clients (built-in Neovim command)

## Troubleshooting

### LSP not starting
- Check binary is in PATH: `which package-swift-lsp`
- Check LSP health: `:checkhealth vim.lsp`
- View LSP logs: `:PackageSwiftLSPLogs`

### No completions
- Save the file after adding dependencies (required for product completions)
- Check LSP server are active: `:LspInfo`

## How it works

This plugin is designed to complement, not replace, `sourcekit-lsp`:

- **sourcekit-lsp**: Handles all standard Swift LSP features (syntax, diagnostics, navigation, etc.)
- **package-swift-lsp**: Provides specialized completions only for Package.swift manifest contexts

Both servers work together seamlessly - you get Swift language support from sourcekit-lsp and smart package completions from package-swift-lsp.

## Contributing

Issues and pull requests are welcome! Please see the main [package-swift-lsp](https://github.com/kattouf/package-swift-lsp) project for feature requests related to the LSP server itself.

## License

MIT License - see [LICENSE](LICENSE) file for details.
