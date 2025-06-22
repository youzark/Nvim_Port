-- Platform Detection Module
local M = {}

-- OS Detection
function M.os()
    local uname = vim.loop.os_uname().sysname:lower()
    if uname:find("darwin") then return "macos"
    elseif uname:find("linux") then return "linux"
    elseif uname:find("windows") then return "windows"
    else return "unknown" end
end

-- Package Manager Detection
function M.package_manager()
    local os_type = M.os()
    if os_type == "linux" then
        if vim.fn.executable("apt") == 1 then return "apt"
        elseif vim.fn.executable("yum") == 1 then return "yum"
        elseif vim.fn.executable("dnf") == 1 then return "dnf"
        elseif vim.fn.executable("pacman") == 1 then return "pacman"
        elseif vim.fn.executable("zypper") == 1 then return "zypper"
        elseif vim.fn.executable("apk") == 1 then return "apk"
        end
    elseif os_type == "macos" then
        if vim.fn.executable("brew") == 1 then return "brew" end
    elseif os_type == "windows" then
        if vim.fn.executable("choco") == 1 then return "chocolatey"
        elseif vim.fn.executable("winget") == 1 then return "winget"
        elseif vim.fn.executable("scoop") == 1 then return "scoop"
        end
    end
    return "manual"
end

-- Environment Detection
function M.environment()
    local env = {
        os = M.os(),
        package_manager = M.package_manager(),
        is_remote = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT"),
        has_display = os.getenv("DISPLAY") or os.getenv("WAYLAND_DISPLAY"),
        is_wsl = vim.fn.has("wsl") == 1,
        arch = vim.loop.os_uname().machine,
    }
    return env
end

return M