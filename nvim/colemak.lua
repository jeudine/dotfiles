-- Colemak-DH movement keys
--
-- On Colemak-DH the keys in the QWERTY h/j/k/l positions are m/n/e/i (the same
-- keys as the arrow layer on the keyboard), so those become the movement keys.
-- Each key they push out moves to the QWERTY key whose job it took:
--
--   m n e i  left, down, up, right       M N E I  top of screen, join lines, hover, bottom of screen
--   h        set mark         (was m)    H        middle of screen      (was M)
--   j        next match       (was n)    J        previous match        (was N)
--   k        end of word      (was e)    K        end of WORD           (was E)
--   l        insert           (was i)    L        insert at line start  (was I)
--
-- Text objects follow the same swap, since l now does i's job: ciw, di( and vif
-- are typed clw, dl( and vlf. AstroNvim's treesitter text objects, snacks' inner
-- scope (ii), Neovim's own `in` and which-key's help for them all move to l as
-- well, so nothing else claims i and it just moves right in visual mode.
--
-- Splits: <C-m/n/e/i> and <C-w>m/n/e/i move between them, <C-w>M/N/E/I move the split itself.

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local maps = opts.mappings

      -- lhs = { rhs, desc, modes }
      local keys = {
        m = { "h", "Left", { "n", "x", "o" } },
        i = { "l", "Right", { "n", "x", "o" } },
        h = { "m", "Set mark", { "n" } },
        j = { "n", "Next match", { "n", "x", "o" } },
        k = { "e", "End of word", { "n", "x", "o" } },
        l = { "i", "Insert", { "n" } },
        M = { "H", "Top of screen", { "n", "x", "o" } },
        N = { "J", "Join lines", { "n", "x" } },
        E = { "K", "Keyword lookup", { "n" } },
        I = { "L", "Bottom of screen", { "n", "x", "o" } },
        H = { "M", "Middle of screen", { "n", "x", "o" } },
        J = { "N", "Previous match", { "n", "x", "o" } },
        K = { "E", "End of WORD", { "n", "x", "o" } },
        L = { "I", "Insert at line start", { "n", "x" } },
      }
      for lhs, key in pairs(keys) do
        for _, mode in ipairs(key[3]) do
          maps[mode][lhs] = { key[1], desc = key[2] }
        end
      end

      -- in visual and operator-pending mode l starts an "inner" text object, as i did
      maps.x["l"] = { "i", desc = "Inside" }
      maps.o["l"] = maps.x["l"]
      -- AstroNvim's treesitter text objects (if, ia, ik, ...) move with it, or i would wait for a second key
      local textobjects = vim.tbl_get(opts, "treesitter", "textobjects", "select", "select_textobject") or {}
      for _, lhs in ipairs(vim.tbl_keys(textobjects)) do
        if lhs:sub(1, 1) == "i" then
          textobjects["l" .. lhs:sub(2)], textobjects[lhs] = textobjects[lhs], nil
        end
      end

      -- like AstroNvim's j/k: move by display line unless a count is given
      maps.n["n"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true, desc = "Move cursor down" }
      maps.x["n"] = maps.n["n"]
      maps.o["n"] = { "j", desc = "Down" }
      maps.n["e"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true, desc = "Move cursor up" }
      maps.x["e"] = maps.n["e"]
      maps.o["e"] = { "k", desc = "Up" }

      maps.n["<C-W>m"] = { "<C-W>h", desc = "Go to the left window" }
      maps.n["<C-W>n"] = { "<C-W>j", desc = "Go to the down window" }
      maps.n["<C-W>e"] = { "<C-W>k", desc = "Go to the up window" }
      maps.n["<C-W>i"] = { "<C-W>l", desc = "Go to the right window" }
      maps.n["<C-W>M"] = { "<C-W>H", desc = "Move window to far left" }
      maps.n["<C-W>N"] = { "<C-W>J", desc = "Move window to far bottom" }
      maps.n["<C-W>E"] = { "<C-W>K", desc = "Move window to far top" }
      maps.n["<C-W>I"] = { "<C-W>L", desc = "Move window to far right" }
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    -- set here rather than in AstroCore, which normalises <C-M>/<C-I> into <CR>/<Tab> and would rebind Enter and Tab
    init = function()
      local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
      map("<C-M>", function() require("smart-splits").move_cursor_left() end, "Move to left split")
      map("<C-N>", function() require("smart-splits").move_cursor_down() end, "Move to below split")
      map("<C-E>", function() require("smart-splits").move_cursor_up() end, "Move to above split")
      map("<C-I>", function() require("smart-splits").move_cursor_right() end, "Move to right split")
      -- <C-M>/<C-I> only stay apart from Enter/Tab when those are mapped too (:h CTRL-I)
      map("<CR>", "<CR>", "Enter")
      map("<Tab>", "<Tab>", "Jump forward")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- Neovim's own `in` (select child node) moves to `ln`, like the treesitter text objects above
    init = function()
      for _, mode in ipairs { "x", "o" } do
        local child_node = vim.fn.maparg("in", mode, false, true)
        if child_node.callback then
          vim.keymap.set(mode, "ln", child_node.callback, { desc = child_node.desc })
          vim.keymap.del(mode, "in")
        end
      end
    end,
  },
  {
    "folke/which-key.nvim",
    -- which-key's text object help makes i a group in visual/operator-pending mode, so which-key would
    -- grab i there instead of letting it move right; show the same help under l instead
    opts = function(_, opts)
      opts.plugins = vim.tbl_deep_extend("force", opts.plugins or {}, { presets = { text_objects = false } })
      local text_objects = vim.deepcopy(require("which-key.plugins.presets").text_objects)
      for _, spec in ipairs(text_objects) do
        if spec[1]:sub(1, 1) == "i" then spec[1] = "l" .. spec[1]:sub(2) end
      end
      opts.spec = vim.list_extend(opts.spec or {}, { text_objects })
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- with K mapped globally Neovim no longer puts LSP hover on it, so E gets it instead
          E = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details", cond = "textDocument/hover" },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          m = "parent_or_close",
          i = "child_or_open",
          e = false, -- falls through to the global "up"
          h = "move",
          k = "toggle_auto_expand_width",
          l = "show_file_details",
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = { keys = { ["n"] = "list_down", ["e"] = "list_up" } },
          list = { keys = { ["n"] = "list_down", ["e"] = "list_up", ["l"] = "focus_input" } },
        },
      },
      scope = {
        keys = {
          textobject = {
            -- the "inner scope" text object moves from ii to li, like the other inner text objects
            ii = false,
            li = {
              min_size = 2,
              edge = false,
              cursor = false,
              treesitter = { blocks = { enabled = false } },
              desc = "inner scope",
            },
          },
        },
      },
    },
  },
}
