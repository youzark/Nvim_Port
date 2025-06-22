require("diffview").setup({
    keymaps = {
        -- This disables all default keymaps
        disable_defaults = true,

        file_panel = {
            ["<tab>"] = require("diffview.config").actions.select_next_entry, -- Cycle to next file with conflicts
            ["<S-tab>"] = require("diffview.config").actions.select_prev_entry, -- Cycle to previous file with conflicts
            ["<enter>"] = require("diffview.config").actions.select_entry,  -- Select a file to view
            -- ["<tab>"] = require("diffview.config").actions.focus_entry,      -- Switch to next file
            ["q"] = require("diffview.config").actions.close,               -- Close the diffview

            -- If you also need basic navigation in the file tree
            ["j"] = require("diffview.config").actions.next_entry,          -- Move cursor down
            ["k"] = require("diffview.config").actions.prev_entry,          -- Move cursor up
        },

        -- File history panel keymaps (for commit browsing)
        file_history_panel = {
            ["<tab>"] = require("diffview.config").actions.select_next_entry, -- Cycle to next file with conflicts
            ["<S-tab>"] = require("diffview.config").actions.select_prev_entry, -- Cycle to previous file with conflicts
            ["<enter>"] = require("diffview.config").actions.select_entry,  -- Select a commit/file to view
            -- ["<tab>"] = require("diffview.config").actions.focus_entry,      -- Switch to next file
            ["q"] = require("diffview.config").actions.close,               -- Close the history view

            -- Basic navigation
            ["j"] = require("diffview.config").actions.next_entry,          -- Move cursor down
            ["k"] = require("diffview.config").actions.prev_entry,          -- Move cursor up
        },
        
        -- Define only the minimal keymaps you need
        view = {
            -- For selectively keeping/reverting hunks when viewing diffs
            ["<tab>"] = require("diffview.config").actions.select_next_entry, -- Cycle to next file with conflicts
            ["<S-tab>"] = require("diffview.config").actions.select_prev_entry, -- Cycle to previous file with conflicts
            ["<leader>co"] = require("diffview.config").actions.diffget("ours"),    -- Keep current version of hunk
            ["<leader>ct"] = require("diffview.config").actions.diffget("theirs"),  -- Take previous version of hunk
            
            -- Essential navigation
            ["q"] = require("diffview.config").actions.close,                       -- Close the diffview
        },
        
        -- For conflict resolution
        merge_tool = {
            -- Choose which version to use for a conflict
            ["<tab>"] = require("diffview.config").actions.select_next_entry, -- Cycle to next file with conflicts
            ["<S-tab>"] = require("diffview.config").actions.select_prev_entry, -- Cycle to previous file with conflicts
            ["J"] = require("diffview.config").actions.conflict_choose("ours"),    -- Choose our version
            ["K"] = require("diffview.config").actions.conflict_choose("theirs"),  -- Choose their version
            
        }
    }
})
