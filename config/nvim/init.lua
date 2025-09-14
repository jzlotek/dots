-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.termguicolors = true

-- Install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", run = ":MasonUpdate", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Useful status updates for LSP.
      {
        "j-hui/fidget.nvim",
        opts = { progress = { display = { progress_icon = { pattern = "dots_negative" } } } },
      },
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
    end,
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
            --   'rafamadriz/friendly-snippets',
            --   config = function()
              --     require('luasnip.loaders.from_vscode').lazy_load()
              --   end,
              -- },
            },
            opts = {},
          },
          'folke/lazydev.nvim',
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
          keymap = {
            -- 'default' (recommended) for mappings similar to built-in completions
            --   <c-y> to accept ([y]es) the completion.
            --    This will auto-import if your LSP supports it.
            --    This will expand snippets if the LSP sent a snippet.
            -- 'super-tab' for tab to accept
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- For an understanding of why the 'default' preset is recommended,
            -- you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            --
            -- All presets have the following mappings:
            -- <tab>/<s-tab>: move to right/left of your snippet expansion
            -- <c-space>: Open menu or open docs if already open
            -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
            -- <c-e>: Hide menu
            -- <c-k>: Toggle signature help
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            preset = 'enter',
            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
          },

          appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
          },

          completion = {
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
          },

          sources = {
            default = { 'lsp', 'path', 'snippets', 'lazydev' },
            providers = {
              lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
          },

          snippets = { preset = 'luasnip' },

          -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
          -- which automatically downloads a prebuilt binary when enabled.
          --
          -- By default, we use the Lua implementation instead, but you may enable
          -- the rust implementation via `'prefer_rust_with_warning'`
          --
          -- See :h blink-cmp-config-fuzzy for more information
          fuzzy = { implementation = 'lua' },

          -- Shows a signature help window while you type arguments for a function
          signature = { enabled = true },
        },
      },

      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
          { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        config = function()
          require('nvim-treesitter.configs').setup {
            ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "typescript", "vim", "vimdoc" },
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true, disable = { "python" } },
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<c-backspace>",
              },
            },
            textobjects = {
              select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ["aa"] = "@parameter.outer",
                  ["ia"] = "@parameter.inner",
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["ac"] = "@class.outer",
                  ["ic"] = "@class.inner",
                },
              },
              move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                  ["]m"] = "@function.outer",
                  ["]]"] = "@class.outer",
                },
                goto_next_end = {
                  ["]M"] = "@function.outer",
                  ["]["] = "@class.outer",
                },
                goto_previous_start = {
                  ["[m"] = "@function.outer",
                  ["[["] = "@class.outer",
                },
                goto_previous_end = {
                  ["[M"] = "@function.outer",
                  ["[]"] = "@class.outer",
                },
              },
              swap = {
                enable = true,
                swap_next = {
                  ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                  ["<leader>A"] = "@parameter.inner",
                },
              },
            },
          }
      end
      },

      "tpope/vim-rhubarb",
      "lewis6991/gitsigns.nvim",

      "rose-pine/neovim",
      {
        'akinsho/bufferline.nvim',
        dependencies = {
          "nvim-lualine/lualine.nvim",
          dependencies = {
            "nvim-tree/nvim-web-devicons",
          }, -- Fancier statusline
        },
      },
      "osyo-manga/vim-brightest",
      { "lukas-reineke/indent-blankline.nvim", main = "ibl" }, -- Add indentation guides even on blank lines
      "numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
      { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
      "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

      -- Fuzzy Finder (files, lsp, etc)
      {
        "nvim-telescope/telescope.nvim",
        --branch = '0.1.x',
        lazy = false,
        dependencies = {
          "nvim-lua/plenary.nvim",
          {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function() return vim.fn.executable 'make' == 1 end,
            config = function()
              require("telescope").load_extension("fzf")
            end,
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-tree/nvim-web-devicons',
          },
        },
      },

      {
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
          { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
        },
        opts = {
          filesystem = {
            window = {
              mappings = {
                ["\\"] = "close_window",
              },
            },
          },
        },
      },
    })


-- [[ Setting options ]]
-- See `:help vim.o`
-- Set highlight on search
vim.o.hlsearch = false
vim.o.lazyredraw = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.cmd([[set background=dark]])
vim.cmd([[colorscheme rose-pine]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"


vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")

vim.keymap.set("n", "S", ":%s//g<Left><Left>")
vim.keymap.set("v", "S", "noop")
vim.keymap.set("v", "S", ":s//g<Left><Left>")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("", "<F6>", ":setlocal spell! spelllang=en_us,es<CR>")

vim.api.nvim_create_autocmd(
  { "FileType" },
  {
    pattern = "*",
    callback = function(opts)
      if vim.api.nvim_buf_get_option(opts.buf, 'modifiable') then
        vim.cmd("%s/\\s\\+$//e")
      end
    end,
  }
)

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    always_show_tabline = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    tabline = {},
  },
})
require("bufferline").setup{}

-- Enable Comment.nvim
require("Comment").setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require("ibl").setup({
  -- indent = { show_trailing_blankline_indent = false, }
  -- char = '┊',
})

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})
-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'fzf')
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)


-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("main-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")

    map("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    vim.diagnostic.config {
      severity_sort = true,
      virtual_lines = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      },
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    -- Create a command `:Format` local to the LSP buffer
    -- vim.api.nvim_buf_create_user_command(buffer, 'Format', function(_) vim.lsp.buf.format() end, { desc = 'Format current buffer with LSP' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
      client
      and client:supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
      then
        local highlight_augroup = vim.api.nvim_create_augroup("main-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("main-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "main-lsp-highlight", buffer = event2.buf })
          end,
        })
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  local servers = {
    clangd = {},
    gopls = {},
    pyright = {},
    rust_analyzer = {},
    tsserver = {},
  }

  local capabilities = require("blink.cmp").get_lsp_capabilities()
  -- Setup mason so it can manage external tooling
  require("mason").setup()

  require("mason-tool-installer").setup{
    ensure_installed = { "clangd", "gopls", "lua-language-server", "basedpyright", "rust-analyzer", "vale" }
  }

  require("mason-lspconfig").setup({
    ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
    automatic_installation = false,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for ts_ls)
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
      end,
    },
  })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
