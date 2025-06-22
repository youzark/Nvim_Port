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

-- Cross-platform clipboard configuration
local function setup_clipboard()
    local env_config = _G.nvim_env or {}
    local os_type = (env_config.os) or vim.loop.os_uname().sysname:lower()
    
    -- Skip if system clipboard is disabled
    if env_config.features and env_config.features.use_system_clipboard == false then
        return
    end
    
    local clipboard_config = nil
    
    if os_type:find("linux") then
        -- Try different clipboard tools in order of preference
        if vim.fn.executable("xclip") == 1 then
            clipboard_config = {
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
        elseif vim.fn.executable("wl-copy") == 1 then
            clipboard_config = {
                name = "wl-clipboard",
                copy = {
                    ["+"] = "wl-copy",
                    ["*"] = "wl-copy",
                },
                paste = {
                    ["+"] = "wl-paste",
                    ["*"] = "wl-paste",
                },
                cache_enabled = false,
            }
        elseif vim.fn.executable("xsel") == 1 then
            clipboard_config = {
                name = "xsel",
                copy = {
                    ["+"] = "xsel -ib",
                    ["*"] = "xsel -ip",
                },
                paste = {
                    ["+"] = "xsel -ob",
                    ["*"] = "xsel -op",
                },
                cache_enabled = false,
            }
        end
    elseif os_type:find("darwin") then
        -- macOS uses pbcopy/pbpaste (usually available by default)
        if vim.fn.executable("pbcopy") == 1 then
            clipboard_config = {
                name = "pbcopy",
                copy = {
                    ["+"] = "pbcopy",
                    ["*"] = "pbcopy",
                },
                paste = {
                    ["+"] = "pbpaste",
                    ["*"] = "pbpaste",
                },
                cache_enabled = false,
            }
        end
    elseif os_type:find("windows") then
        -- Windows clipboard via clip.exe and powershell
        clipboard_config = {
            name = "win32yank",
            copy = {
                ["+"] = "win32yank.exe -i --crlf",
                ["*"] = "win32yank.exe -i --crlf",
            },
            paste = {
                ["+"] = "win32yank.exe -o --lf",
                ["*"] = "win32yank.exe -o --lf",
            },
            cache_enabled = false,
        }
    end
    
    if clipboard_config then
        vim.g.clipboard = clipboard_config
    else
        -- Fallback to neovim's default clipboard handling
        vim.opt.clipboard = "unnamedplus"
    end
end

setup_clipboard()

