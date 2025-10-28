-- =========================
-- Basics / Optionen
-- =========================
vim.g.mapleader = ","

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.gdefault = true
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", extends = "…", precedes = "…" }
vim.opt.clipboard = "unnamedplus"
vim.opt.laststatus = 3

-- Encoding: intern UTF-8, beim Einlesen mehrere Kandidaten probieren (Reihenfolge wichtig)
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "ucs-bom", "utf-8", "cp1252", "iso-8859-1", "latin1" }
vim.opt.bomb = false -- kein BOM schreiben

-- Yank-Highlight (visuelles Feedback)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- =========================
-- lazy.nvim bootstrap
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "lewis6991/gitsigns.nvim" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "hedyhli/outline.nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "nvim-telescope/telescope-project.nvim" },
  { "folke/persistence.nvim" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    opts = {},
  },
  { "dkarter/bullets.vim", ft = { "markdown", "text" } },
  {
    "nelsyeung/twig.vim",
    ft = "twig",
  },
  {
    "sotte/presenting.nvim",
    opts = {
        width = 80,
      -- fill in your options here
      -- see :help Presenting.config
    },
    cmd = { "Presenting" },
  },

  -- LSP + Autocomplete
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "ludovicchabant/vim-gutentags" },

  -- XDebug / DAP
  { "mfussenegger/nvim-dap" },
  { "nvim-neotest/nvim-nio" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },
  { "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" } },
  { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

  -- conform
  { "stevearc/conform.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },

  -- autoclose
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },

  -- =========================
  -- 🔥 NEUE FANCY PLUGINS
  -- =========================

  -- noice.nvim: moderne UI (Cmdline, Messages, Popups)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      messages = { view_search = false },
    },
  },

  -- nvim-spectre: Suche & Ersetzen über das ganze Projekt
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- lazy lädt jetzt automatisch beim ersten Keypress
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace (Spectre)" },
      -- optional nützlich:
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre: word under cursor" },
      { "<leader>sf", function() require("spectre").open_file_search() end, desc = "Spectre: current file" },
    },
    opts = {}, -- default-setup
  },

  -- image.nvim: Bilder inline anzeigen (nur in Kitty laden)
  {
    "3rd/image.nvim",
    cond = function()
      return vim.env.KITTY_WINDOW_ID ~= nil
    end,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto", "org" },
        },
      },
      max_width = 100,
      max_height = 40,
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
    },
  },
})

-- =========================
-- Theme
-- =========================
require("catppuccin").setup({
  flavour = "macchiato",
  integrations = {
    treesitter = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    cmp = true,
  },
})
vim.cmd.colorscheme("catppuccin")

-- =========================
-- Telescope
-- =========================
local telescope = require("telescope")
local project_actions = require("telescope._extensions.project.actions")

-- kleine Helfer: alle Buffer, die NICHT im neuen Projekt liegen, schließen
local function close_foreign_buffers(new_root)
  local prefix = vim.pesc(new_root .. "/")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and not name:match("^" .. prefix) and not name:match("^term://") then
        if vim.api.nvim_buf_get_option(buf, "modified") then
          pcall(vim.api.nvim_buf_call, buf, function()
            vim.cmd("silent! write")
          end)
        end
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end
end

telescope.setup({
  pickers = {
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      mappings = {
        i = { ["<C-d>"] = "delete_buffer" },
        n = { ["d"] = "delete_buffer" },
      },
    },
  },
  extensions = {
    project = {
      theme = "dropdown",
      hidden_files = true,
      sync_with_nvim_tree = true,
      on_project_selected = function(prompt_bufnr)
        -- 1) Nur Verzeichnis wechseln (kein find_files)
        project_actions.change_working_directory(prompt_bufnr, false)

        -- 2) Fremde Buffer schließen
        local new_root = vim.loop.cwd()
        close_foreign_buffers(new_root)

        -- 3) Projekt-Session laden (falls vorhanden)
        pcall(function()
          require("persistence").load()
        end)

        -- 4) Tree öffnen/syncen, Fokus zurück in Code
        local api = require("nvim-tree.api")
        if not api.tree.is_visible() then
          api.tree.open()
        end
        api.tree.change_root(new_root)
        api.tree.reload()
        vim.cmd("wincmd p")
      end,
    },
  },
})

telescope.load_extension("project")
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<CR>", { desc = "Projects" })

-- =========================
-- Persistence
-- =========================
require("persistence").setup({
  dir = vim.fn.stdpath("state") .. "/sessions/",
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

-- Beim Start ohne Dateiargumente: letzte Session laden (wie „Reopen last project“)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      pcall(function()
        require("persistence").load({ last = true })
      end)
    end
  end,
})

vim.keymap.set("n", "<leader>qs", function()
  require("persistence").save()
end, { desc = "Session save" })
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load()
end, { desc = "Session load (cwd)" })

-- =========================
-- Signature
-- =========================
require("lsp_signature").setup({
  bind = true,
  hint_enable = true,
  handler_opts = { border = "rounded" },
})

-- =========================
-- XDebug / DAP
-- =========================
require("mason-nvim-dap").setup({
  ensure_installed = { "php" }, -- installiert vscode-php-debug
  automatic_installation = true,
})

require("nvim-dap-virtual-text").setup()
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local phpdbg = vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js"
dap.adapters.php = { type = "executable", command = "node", args = { phpdbg } }

dap.configurations.php = {
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug",
    port = 9003, -- Xdebug 3 Standard
    log = false,
    pathMappings = {},
  },
}

local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = "DAP: " .. desc })
end
map("<leader>dt", function() dapui.toggle() end, "UI toggle")
map("<leader>dc", function() dap.continue() end, "Continue / Listen")
map("<leader>dn", function() dap.step_over() end, "Step Over")
map("<leader>di", function() dap.step_into() end, "Step Into")
map("<leader>do", function() dap.step_out() end, "Step Out")
map("<leader>db", function() dap.toggle_breakpoint() end, "Toggle Breakpoint")
map("<leader>dB", function() dap.set_breakpoint(vim.fn.input("cond: ")) end, "Conditional BP")
map("<leader>dr", function() dap.repl.toggle() end, "REPL")
vim.keymap.set("n", ",dq", function()
  require("dapui").close()
  require("dap").terminate()
end, { desc = "Xdebug / DAP schließen" })

-- =========================
-- Outline
-- =========================
require("outline").setup({
  outline_window = {
    position = "right",
    width = 34,
  },
  symbols = {
    show_filename = false,
  },
})
vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle symbol outline" })

-- =========================
-- Lualine (Statusleiste)
-- =========================
require("lualine").setup({
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "branch", icon = "" }, "diff" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      function()
        return vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
      end,
      function()
        return vim.bo.fileformat
      end,
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- =========================
-- nvim-tree (Dateibaum)
-- =========================
require("nvim-tree").setup({
  view = { width = 34 },
  renderer = {
    group_empty = true,
    highlight_git = "name",
    icons = { show = { git = true } },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  git = {
    enable = true,
    ignore = false,
  },
  update_focused_file = {
    enable = true,   -- folgt dem aktiven Buffer
    update_root = false, -- Root nicht automatisch ändern
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Default keymaps + eigene Ergänzungen
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "L", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "H", api.tree.change_root_to_parent, opts("Up a Directory"))
  end,
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvim-tree" })

-- =========================
-- Telescope (Datei/Grep) – Keymaps
-- =========================
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })

-- =========================
-- Twit
-- =========================
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.twig",
    command = "set filetype=twig",
})

-- =========================
-- Treesitter
-- =========================
require("nvim-treesitter.configs").setup({
  ensure_installed = { "php", "phpdoc", "html", "css", "javascript", "json", "lua", "bash", "markdown", "yaml", "twig" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- =========================
-- Git-Signs
-- =========================
require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
})

-- =========================
-- Indent Guides
-- =========================
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = false },
})
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#363A4F", nocombine = true })

-- =========================
-- LSP + Autocomplete (neue API)
-- =========================
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "intelephense" } })

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
  }),
  sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Neue LSP-API (0.11+)
vim.lsp.config("intelephense", {
  capabilities = capabilities,
})
vim.lsp.enable("intelephense")

-- Keymaps für LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- =========================
-- Buffer-Shortcuts
-- =========================
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer prev" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Buffer delete" })

local function dim_git_ignored()
  local dim = "#6e738d"
  vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = dim, italic = true, nocombine = true })
  vim.api.nvim_set_hl(0, "NvimTreeFileIgnored", { fg = dim, italic = true, nocombine = true })
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, { callback = dim_git_ignored })
dim_git_ignored()

-- === Öffne nvim-tree beim Start, aber behalte Fokus in der Datei ===
local function open_nvim_tree(data)
  local api = require("nvim-tree.api")
  local is_dir = vim.fn.isdirectory(data.file) == 1

  if is_dir then
    vim.cmd.cd(data.file)
    api.tree.open()
    return
  end

  api.tree.open()
  api.tree.find_file({ open = false }) -- markiert die Datei im Baum
  vim.cmd("wincmd p") -- zurück zur Datei
end

vim.api.nvim_create_autocmd("VimEnter", { callback = open_nvim_tree })

-- Schließt nvim-tree automatisch, wenn es das letzte Fenster ist
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()

    for _, w in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(w)
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      local cfg = vim.api.nvim_win_get_config(w)
      if ft == "NvimTree" then
        table.insert(tree_wins, w)
      elseif cfg.relative ~= "" then
        table.insert(floating_wins, w)
      end
    end

    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})

-- =========================
-- Harpoon (v2)
-- =========================
do
  local ok, harpoon = pcall(require, "harpoon")
  if ok then
    harpoon:setup()

    -- Dateien zur Harpoon-Liste hinzufügen / Menü öffnen
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon: add file" })
    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: menu" })

    -- Direktzugriffe auf Slots
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
  end
end

-- =========================
-- Scratch Files (permanent)
-- =========================
do
  local scratch_dir = vim.fn.expand("~/.local/share/nvim/scratch")
  vim.fn.mkdir(scratch_dir, "p")

  -- :Scratch [ext] -> erstellt/öffnet neue Datei
  vim.api.nvim_create_user_command("Scratch", function(opts)
    local ext = (opts.args ~= "" and opts.args) or "md"
    local name = os.date("%Y-%m-%d_%H%M%S") .. "." .. ext
    local path = scratch_dir .. "/" .. name
    vim.cmd("edit " .. path)
    print("Scratch: " .. path)
  end, {
    nargs = "?",
    complete = function()
      return { "md", "txt", "php", "js", "lua" }
    end,
  })

  -- :ScratchList -> Telescope-Auswahl im Scratch-Ordner
  vim.api.nvim_create_user_command("ScratchList", function()
    require("telescope.builtin").find_files({
      cwd = scratch_dir,
      prompt_title = "Scratch",
      hidden = true,
    })
  end, {})

  -- Keymaps
  vim.keymap.set("n", "<leader>ss", ":Scratch md<CR>", { desc = "Scratch: neu (md)" })
  vim.keymap.set("n", "<leader>sl", ":ScratchList<CR>", { desc = "Scratch: liste" })
end

-- =========================
-- Encoding Auto-Detection (uchardet) + Reopen
-- =========================
-- Tipp: brew install uchardet
-- Debug toggeln: :lua vim.g.autoencoding_debug = true

local function map_uchardet_to_vim(enc)
  enc = (enc or ""):lower():gsub("%s+", "")
  if enc == "utf-8" or enc == "utf8" then
    return "utf-8"
  end
  if enc == "iso-8859-1" or enc == "iso8859-1" then
    return "iso-8859-1"
  end
  if enc == "windows-1252" or enc == "cp1252" then
    return "cp1252"
  end
  if enc == "us-ascii" then
    return "latin1"
  end -- konservativ
  return nil
end

local function reopen_with_encoding(enc, force)
  local view = vim.fn.winsaveview()
  local cmd = (force and "edit! ++enc=" or "edit ++enc=") .. enc .. " %"
  vim.cmd("silent keepalt keepjumps " .. cmd)
  vim.fn.winrestview(view)
  vim.bo.fileencoding = enc -- beim Speichern im erkannten Encoding zurück
  if vim.g.autoencoding_debug then
    vim.notify("Encoding: reopened as " .. enc, vim.log.levels.INFO)
  end
end

local function detect_and_reopen(bufnr, filepath, opts)
  opts = opts or {}
  if vim.fn.executable("uchardet") ~= 1 then
    return
  end
  if not filepath or filepath == "" then
    return
  end

  if not opts.now then
    return vim.schedule(function()
      detect_and_reopen(bufnr, filepath, { now = true })
    end)
  end

  local out = vim.fn.system({ "uchardet", filepath })
  if vim.v.shell_error ~= 0 then
    return
  end

  local enc = map_uchardet_to_vim(out)
  if not enc then
    return
  end

  local current = (vim.bo[bufnr].fileencoding ~= "" and vim.bo[bufnr].fileencoding or vim.o.encoding)
  if current:lower() == enc:lower() then
    if vim.g.autoencoding_debug then
      vim.notify("Encoding already " .. current, vim.log.levels.DEBUG)
    end
    return
  end

  if vim.bo[bufnr].modified and not opts.force then
    if vim.g.autoencoding_debug then
      vim.notify("Skip auto-reopen (modified buffer). Use :DetectEnc! to force.", vim.log.levels.WARN)
    end
    return
  end

  reopen_with_encoding(enc, opts.force)
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("autoencoding_detect", { clear = true }),
  callback = function(args)
    local name = args.file:lower()
    if name:match("%.%w+$") and not name:match("%.(png|jpg|jpeg|gif|pdf|zip|tar|gz|7z|mp3|mp4)$") then
      detect_and_reopen(args.buf, args.file)
    end
  end,
})

-- Manuell triggern (mit !-Semantik über <bang>)
vim.api.nvim_create_user_command("DetectEnc", function(opts)
  detect_and_reopen(0, vim.api.nvim_buf_get_name(0), { force = opts.bang })
end, { bang = true })

-- Ad-hoc in gewünschtem Encoding speichern, ohne Buffer-Option zu ändern
vim.api.nvim_create_user_command("SaveAsEnc", function(opts)
  local enc = opts.args
  if enc == nil or enc == "" then
    return
  end
  vim.cmd("write ++enc=" .. enc)
end, {
  nargs = 1,
  complete = function()
    return { "utf-8", "cp1252", "iso-8859-1", "latin1" }
  end,
})

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Letzte Datei" })

-- =========================
-- Markdown: Softwrap
-- =========================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- j und k Navigation bei Softwrap
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Mason-Tool-Installer: sorgt dafür, dass die Binaries da sind
require("mason-tool-installer").setup({
  ensure_installed = {
    "php-cs-fixer",
    "phpcs",
    "prettier",
    "prettierd",
    "stylua",
  },
  auto_update = false,
  run_on_start = true,
})

-- Conform: Formatierer je Filetype (Autoformat AUS, manuell mit ,af)
require("conform").setup({
  formatters_by_ft = {
    php = { "phpcbf", "php_cs_fixer" },
    html = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    lua = { "stylua" },
    ["*"] = { "trim_whitespace" },
  },
  format_on_save = false, -- wichtig: NICHT automatisch beim Speichern
})

-- Bequemer Shortcut: manuelles Formatieren
vim.keymap.set({ "n", "x" }, "<leader>af", function()
  require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Format file/range" })

-- Autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({})

-- Integration mit nvim-cmp (schließt Klammern nach Completion)
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Auto-Tag (HTML, JSX, Vue, …)
require("nvim-ts-autotag").setup({
  opts = { enable_close_on_slash = true },
})

-- Markdown
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
})

-- Markdown -> HTML/PDF aus Neovim
local function md_export(fmt)
  local input = vim.fn.expand("%")
  local base  = vim.fn.expand("%:r")
  local cmd
  if fmt == "pdf" then
    cmd = { "pandoc", input, "-o", base .. ".pdf",
            "--from=markdown+smart",
            "--pdf-engine=tectonic",
            "-V", "geometry:margin=2.5cm" }   -- Rand optional
  else
    cmd = { "pandoc", input, "-o", base .. ".html",
            "--from=markdown+smart", "-s" }
  end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Export " .. fmt .. " ✔")
        local outfile = base .. "." .. fmt
        if vim.fn.has("mac") == 1 then
          vim.fn.jobstart({ "open", outfile })
        elseif vim.fn.executable("xdg-open") == 1 then
          vim.fn.jobstart({ "xdg-open", outfile })
        end
      else
        vim.notify("Export " .. fmt .. " fehlgeschlagen", vim.log.levels.ERROR)
      end
    end,
  })
end

vim.api.nvim_create_user_command("MdHtml", function() md_export("html") end, {})
vim.api.nvim_create_user_command("MdPdf",  function() md_export("pdf")  end, {})
vim.keymap.set("n", ",mh", ":MdHtml<CR>", { silent = true })
vim.keymap.set("n", ",mp", ":MdPdf<CR>",  { silent = true })


-- =========================
-- Tags
-- =========================
--
-- ctags-Dateien auch in Parent-Dirs finden
vim.opt.tags = "./tags;,tags;"

-- gutentags: Cache & Verhalten
vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/tags"
vim.g.gutentags_project_root = { ".git", "composer.json", ".hg", ".project_root" }
vim.g.gutentags_ctags_executable = vim.fn.exepath("ctags")

-- Nur PHP parsen, saubere Felder; TOML-Quatsch stumm schalten
vim.g.gutentags_ctags_extra_args = {
  "--languages=PHP",
  "--php-kinds=cf",
  "--fields=+niazS",
  "--extras=+q",
  "--options=/dev/null",
}

-- Generieren: beim Öffnen/Schreiben/Fehlen
vim.g.gutentags_generate_on_write = 1
vim.g.gutentags_generate_on_missing = 1
vim.g.gutentags_generate_on_new = 1

-- Große Verzeichnisse ausschließen
vim.g.gutentags_ctags_exclude = {
  "vendor", "node_modules", "var", "cache", "public/build",
  ".git", ".hg", ".svn", "*.min.js", "*.min.css"
}

vim.keymap.set("n", "<leader>jd", "<C-]>", { desc = "ctags: go to definition" })
vim.keymap.set("n", "<leader>jb", "<C-t>", { desc = "ctags: back" })
