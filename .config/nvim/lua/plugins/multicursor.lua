return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  lazy = false,

  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({"n", "x"}, "<c-s-up>", function() mc.lineAddCursor(-1) end)
    set({"n", "x"}, "<c-s-down>", function() mc.lineAddCursor(1) end)
    set({"n", "x"}, "<c-s-k>", function() mc.lineAddCursor(-1) end)
    set({"n", "x"}, "<c-s-j>", function() mc.lineAddCursor(1) end)

    set({"n", "x"}, "<c-a-s-up>", function() mc.lineSkipCursor(-1) end)
    set({"n", "x"}, "<c-a-s-down>", function() mc.lineSkipCursor(1) end)
    set({"n", "x"}, "<c-a-s-k>", function() mc.lineSkipCursor(-1) end)
    set({"n", "x"}, "<c-a-s-j>", function() mc.lineSkipCursor(1) end)

    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse)
    set("n", "<c-leftdrag>", mc.handleMouseDrag)
    set("n", "<c-leftrelease>", mc.handleMouseRelease)

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)

      -- Select a different cursor as the main one.
      layerSet({"n", "x"}, "<left>", mc.prevCursor)
      layerSet({"n", "x"}, "<right>", mc.nextCursor)

      -- Delete the main cursor.
      layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end
}
