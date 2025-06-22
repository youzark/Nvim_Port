local is_remote = (vim.env.XDG_CONFIG_HOME and vim.env.XDG_CONFIG_HOME:find("remote%-nvim")) ~= nil

require("remote-nvim").setup({
    client_callback = function(port, workspace_config)
        local cmd

        if vim.env.TERM == "xterm-kitty" then
          cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
        elseif vim.env.TERM:find("iterm") or vim.env.TERM_PROGRAM == "iTerm.app" then
            local applescript = string.format([[
                osascript -e '
                    tell application "iTerm2"
                        tell current window
                            create tab with default profile
                            tell current session of current tab
                                write text "nvim --server localhost:%s --remote-ui"
                            end tell
                        end tell
                    end tell
                '
            ]], port)
          cmd = applescript
        else
            cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
                port,
                ("'Remote: %s'"):format(workspace_config.host)
            )
        end

        vim.fn.jobstart(cmd, {
            detach = true,
            on_exit = function(job_id, exit_code, event_type)
                -- This function will be called when the job exits
                print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
            end,
        })
    end,
})

vim.g.clipboard = {
    name = "xclip",
    copy = {
        ["+"] = "xclip -i -selection clipboard",
        ["*"] = "xclip -i -selection clipboard",
    },
    paste = {
        ["+"] = "xclip -o -selection clipboard",
        ["*"] = "xclip -o -selection clipboard",
    },
    cache_enabled = false,
}

