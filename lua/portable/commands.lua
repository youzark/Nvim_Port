-- Portable Commands Module
local detect = require('portable.detect')
local deps = require('portable.deps')
local python_env = require('portable.python_env')
local tool_manager = require('portable.tool_manager')
local M = {}

-- Setup all portable commands
function M.setup()
    -- Check dependencies
    vim.api.nvim_create_user_command("PortableCheck", function()
        deps.print_status()
        print("\n")
        python_env.print_status()
        print("\n")
        tool_manager.print_status()
    end, { desc = "Check portable dependencies" })
    
    -- Install dependencies
    vim.api.nvim_create_user_command("PortableInstall", function(args)
        local category = args.args ~= "" and args.args or "core"
        
        if category == "python" then
            python_env.setup()
        elseif category == "essentials" then
            tool_manager.install_essentials()
        elseif tool_manager.presets[category] then
            tool_manager.install_preset(category)
        else
            deps.install(category)
        end
    end, {
        nargs = "?",
        complete = function() 
            return {"core", "languages", "tools", "optional", "python", "essentials", "web_dev", "data_science", "latex", "minimal"}
        end,
        desc = "Install portable dependencies"
    })
    
    -- Environment info
    vim.api.nvim_create_user_command("PortableInfo", function()
        local env = detect.environment()
        
        print("Portable Environment Info:")
        print("=" .. string.rep("=", 30))
        print("OS: " .. env.os .. " (" .. env.arch .. ")")
        print("Package Manager: " .. env.package_manager)
        print("Remote: " .. (env.is_remote and "Yes" or "No"))
        print("Display: " .. (env.has_display and "Yes" or "No"))
        print("WSL: " .. (env.is_wsl and "Yes" or "No"))
        print("Python: " .. (vim.g.python3_host_prog or "not configured"))
        print("Clipboard: " .. (vim.g.clipboard and vim.g.clipboard.name or "default"))
        print("PDF Viewer: " .. (vim.g.vimtex_view_method or "not configured"))
        print("Browser: " .. (vim.g.mkdp_browser or "not configured"))
    end, { desc = "Show portable environment info" })
    
    -- Setup portable enhancements
    vim.api.nvim_create_user_command("PortableSetup", function()
        require('portable').setup()
        print("[PORTABLE] Enhancements applied to current session")
    end, { desc = "Apply portable enhancements" })
    
    -- Show portable status
    vim.api.nvim_create_user_command("PortableStatus", function()
        local enabled = _G.nvim_portable ~= nil
        print("Portable Status: " .. (enabled and "ENABLED" or "DISABLED"))
        if enabled then
            print("OS: " .. _G.nvim_portable.os)
            print("Package Manager: " .. _G.nvim_portable.package_manager)
        end
    end, { desc = "Show portable system status" })
    
    -- Python environment commands
    vim.api.nvim_create_user_command('PythonEnvSetup', function()
        python_env.setup()
    end, { desc = 'Setup Python environment with miniconda' })
    
    vim.api.nvim_create_user_command('PythonEnvStatus', function()
        python_env.print_status()
    end, { desc = 'Show Python environment status' })
    
    vim.api.nvim_create_user_command('InstallMiniconda', function()
        python_env.install_miniconda()
    end, { desc = 'Install miniconda automatically' })
    
    -- Interactive Python setup guide
    vim.api.nvim_create_user_command('PythonSetupGuide', function()
        local python_env = require('portable.python_env')
        
        print("🐍 PYTHON SETUP GUIDE")
        print("═" .. string.rep("═", 60))
        
        -- Check current state
        local conda_path = python_env.detect_conda()
        local has_conda = conda_path ~= nil
        local has_env = has_conda and python_env.env_exists(conda_path)
        local python_configured = vim.g.python3_host_prog ~= nil
        
        print("📊 Current Status:")
        print("   🐍 Conda: " .. (has_conda and "✅ Found" or "❌ Not found"))
        if has_conda then
            print("      📁 Path: " .. conda_path)
        end
        print("   🏠 Nvim Environment: " .. (has_env and "✅ Exists" or "❌ Missing"))
        print("   ⚙️  Python Host: " .. (python_configured and "✅ Configured" or "❌ Not configured"))
        print("")
        
        -- Provide recommendations
        print("💡 RECOMMENDATIONS:")
        print("═" .. string.rep("═", 60))
        
        if not has_conda then
            print("1️⃣  INSTALL CONDA (Required)")
            print("   🚀 Quick install: :InstallMiniconda")
            print("   📖 Manual install: See commands below")
            print("")
        end
        
        if has_conda and not has_env then
            print("2️⃣  CREATE PYTHON ENVIRONMENT")
            print("   🎯 Run: :PythonEnvSetup")
            print("   📦 Will create 'nvim' environment with all packages")
            print("")
        end
        
        if has_conda and has_env and not python_configured then
            print("3️⃣  CONFIGURE NVIM")
            print("   ⚙️  Run: :PythonEnvSetup")
            print("   🔗 Will set Python host for nvim")
            print("")
        end
        
        if has_conda and has_env and python_configured then
            print("✅ SETUP COMPLETE!")
            print("   🎉 Your Python environment is ready")
            print("   📊 Status: :PythonEnvStatus")
            print("")
        end
        
        -- Quick actions
        print("🚀 QUICK ACTIONS:")
        print("═" .. string.rep("═", 60))
        if not has_conda then
            print("   :InstallMiniconda      - Auto-install conda")
            print("   :PythonSetupManual     - Manual installation commands")
        else
            print("   :PythonEnvSetup        - Setup/update environment")
            print("   :PythonEnvStatus       - Check detailed status")
        end
        print("   :PortableInstall python - Complete Python setup")
        print("")
        
    end, { desc = 'Interactive Python setup guide' })
    
    -- Manual installation commands
    vim.api.nvim_create_user_command('PythonSetupManual', function()
        local os_type = require('portable.detect').os()
        
        print("📖 MANUAL PYTHON SETUP COMMANDS")
        print("═" .. string.rep("═", 60))
        
        if os_type == "linux" then
            print("🐧 LINUX INSTALLATION:")
            print("   # Option 1: Download and install miniconda")
            print("   curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh")
            print("   bash ~/miniconda.sh -b -p ~/miniconda3")
            print("   ~/miniconda3/bin/conda init")
            print("")
            print("   # Option 2: Package manager (if available)")
            print("   sudo apt install conda          # Ubuntu/Debian")
            print("   sudo pacman -S miniconda3       # Arch Linux") 
            print("   sudo yum install conda          # RHEL/CentOS")
            
        elseif os_type == "macos" then
            print("🍎 MACOS INSTALLATION:")
            print("   # Option 1: Download and install miniconda")
            print("   curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda.sh")
            print("   bash ~/miniconda.sh -b -p ~/miniconda3")
            print("   ~/miniconda3/bin/conda init")
            print("")
            print("   # Option 2: Homebrew")
            print("   brew install miniconda")
            
        else
            print("🪟 WINDOWS INSTALLATION:")
            print("   Download installer from: https://docs.conda.io/en/latest/miniconda.html")
            print("   Run the .exe installer and follow instructions")
        end
        
        print("")
        print("🔄 AFTER INSTALLATION:")
        print("   1. Restart your terminal or run: source ~/.bashrc")
        print("   2. Run: :PythonEnvSetup")
        print("   3. Verify: conda --version")
        
    end, { desc = 'Show manual Python setup commands' })
    
    -- AppImage diagnostics and fixes
    vim.api.nvim_create_user_command('AppImageInfo', function()
        local appimage_fix = require('portable.appimage_fix')
        appimage_fix.show_info()
    end, { desc = 'Show AppImage environment information' })
    
    vim.api.nvim_create_user_command('AppImageFix', function()
        local appimage_fix = require('portable.appimage_fix')
        if appimage_fix.is_appimage() then
            appimage_fix.apply_fixes()
        else
            print("[APPIMAGE-FIX] Not running in AppImage environment")
        end
    end, { desc = 'Apply AppImage compatibility fixes' })
    
    -- Tool manager commands
    vim.api.nvim_create_user_command('ToolInstall', function(opts)
        local tool = opts.args
        if tool == "" then
            print("Usage: :ToolInstall <tool_name>")
            print("Available tools: npm, luarocks, ranger, ripgrep, fd, fzf, latex")
            return
        end
        tool_manager.install_tool(tool)
    end, {
        nargs = 1,
        complete = function() 
            local tools = {}
            for name, _ in pairs(tool_manager.tools) do
                table.insert(tools, name)
            end
            return tools
        end,
        desc = 'Install specific tool'
    })
    
    vim.api.nvim_create_user_command('ToolPackages', function(opts)
        local tool = opts.args
        if tool == "" then
            print("Usage: :ToolPackages <tool_name>")
            print("Available: npm, luarocks")
            return
        end
        tool_manager.install_packages(tool)
    end, {
        nargs = 1,
        complete = function() return {"npm", "luarocks"} end,
        desc = 'Install packages for specific tool'
    })
    
    -- Clipboard management commands
    vim.api.nvim_create_user_command('ClipboardForceInternal', function()
        local tmp_file = vim.fn.stdpath('cache') .. '/clipboard.txt'
        vim.g.clipboard = {
            name = "internal-file-forced",
            copy = {
                ["+"] = function(lines) 
                    local file = io.open(tmp_file, 'w')
                    if file then
                        file:write(table.concat(lines, '\n'))
                        file:close()
                        print("Copied to internal clipboard")
                    end
                end,
                ["*"] = function(lines)
                    local file = io.open(tmp_file, 'w')
                    if file then
                        file:write(table.concat(lines, '\n'))
                        file:close()
                        print("Copied to internal clipboard")
                    end
                end
            },
            paste = {
                ["+"] = function()
                    local file = io.open(tmp_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        return vim.split(content, '\n', {plain = true})
                    end
                    return {}
                end,
                ["*"] = function()
                    local file = io.open(tmp_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        return vim.split(content, '\n', {plain = true})
                    end
                    return {}
                end
            },
            cache_enabled = false,
        }
        print("Forced internal clipboard mode (no system clipboard errors)")
    end, { desc = 'Force internal clipboard to avoid display errors' })
    
    vim.api.nvim_create_user_command('ClipboardInfo', function()
        local clipboard_name = vim.g.clipboard and vim.g.clipboard.name or "default"
        print("🔍 CLIPBOARD DIAGNOSTICS")
        print("=" .. string.rep("=", 50))
        print("Current clipboard: " .. clipboard_name)
        print("Clipboard setting: " .. vim.o.clipboard)
        
        -- Environment detection
        local is_docker = os.getenv("container") == "docker" or vim.fn.filereadable("/.dockerenv") == 1
        local is_ssh = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
        local has_display = os.getenv("DISPLAY") ~= nil and os.getenv("DISPLAY") ~= ""
        
        -- SSH hop detection
        local ssh_hop_depth = 0
        if is_ssh then
            local display = os.getenv("DISPLAY") or ""
            local display_num = display:match("localhost:(%d+)")
            if display_num then
                ssh_hop_depth = math.max(1, math.floor(tonumber(display_num) / 10))
            elseif is_ssh then
                ssh_hop_depth = 1
            end
        end
        
        print("")
        print("📡 NETWORK TOPOLOGY:")
        print("SSH connection: " .. (is_ssh and "yes" or "no"))
        if is_ssh then
            print("SSH hop depth: " .. ssh_hop_depth .. (ssh_hop_depth > 1 and " (multi-hop)" or " (direct)"))
        end
        print("Docker container: " .. (is_docker and "yes" or "no"))
        print("Display available: " .. (has_display and "yes" or "no"))
        
        -- Test clipboard functionality with progressive timeouts
        print("")
        print("🧪 CLIPBOARD TESTS:")
        
        if vim.fn.executable("xclip") == 1 then
            -- Quick X11 test
            local x11_test = vim.fn.system("timeout 1s xset q >/dev/null 2>&1")
            print("X11 server: " .. (vim.v.shell_error == 0 and "✅ accessible" or "❌ not accessible"))
            
            -- Clipboard access test with appropriate timeout
            local timeout = 2 + (ssh_hop_depth * 2)
            print("Testing clipboard access (timeout: " .. timeout .. "s)...")
            local start_time = os.time()
            local result = vim.fn.system(string.format("timeout %ds xclip -o -selection clipboard 2>/dev/null", timeout))
            local elapsed = os.time() - start_time
            local clipboard_test = vim.v.shell_error == 0 and "✅ working" or "❌ failed"
            print("Clipboard access: " .. clipboard_test .. " (" .. elapsed .. "s)")
        else
            print("xclip: ❌ not installed")
        end
        
        print("")
        print("🌐 ENVIRONMENT VARIABLES:")
        local env_vars = {
            {"DISPLAY", os.getenv("DISPLAY")},
            {"SSH_CONNECTION", os.getenv("SSH_CONNECTION")},
            {"SSH_CLIENT", os.getenv("SSH_CLIENT")},
            {"container", os.getenv("container")},
            {"TERM", os.getenv("TERM")}
        }
        
        for _, var in ipairs(env_vars) do
            local name, value = var[1], var[2]
            print(string.format("%-15s: %s", name, value or "not set"))
        end
        
        print("")
        print("💡 RECOMMENDATIONS:")
        if ssh_hop_depth > 1 then
            print("• Multi-hop SSH detected - clipboard may be slow")
            print("• Consider using 'network_clipboard' mode for better reliability")
        end
        if is_docker and not has_display then
            print("• Docker without X11 - using bridge mode")
            print("• Run with: docker run -v /tmp:/tmp -e DISPLAY=$DISPLAY")
        end
        if is_ssh and not vim.v.shell_error == 0 then
            print("• SSH X11 forwarding issues detected")
            print("• Check: ssh -X or ssh -Y flag usage")
        end
    end, { desc = 'Show detailed clipboard diagnostics and environment analysis' })
    
    -- Docker clipboard bridge command
    vim.api.nvim_create_user_command('ClipboardSetupDockerBridge', function()
        print("Setting up Docker clipboard bridge...")
        print("This requires running Docker with: -v /tmp:/tmp")
        print("And host must have xclip installed with X11 forwarding")
        
        local bridge_file = "/tmp/nvim_docker_clipboard"
        vim.g.clipboard = {
            name = "docker-bridge-manual",
            copy = {
                ["+"] = function(lines)
                    local content = table.concat(lines, '\n')
                    local file = io.open(bridge_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        print("Copied to bridge file: " .. bridge_file)
                        print("Run on host: xclip -i -selection clipboard < " .. bridge_file)
                    end
                end,
                ["*"] = function(lines)
                    local content = table.concat(lines, '\n')
                    local file = io.open(bridge_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        print("Copied to bridge file: " .. bridge_file)
                    end
                end
            },
            paste = {
                ["+"] = function()
                    print("Run on host first: xclip -o -selection clipboard > " .. bridge_file)
                    local file = io.open(bridge_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        if content and content ~= "" then
                            return vim.split(content, '\n', {plain = true})
                        end
                    end
                    return {}
                end,
                ["*"] = function()
                    local file = io.open(bridge_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        if content and content ~= "" then
                            return vim.split(content, '\n', {plain = true})
                        end
                    end
                    return {}
                end
            },
            cache_enabled = false,
        }
        print("Docker clipboard bridge enabled")
    end, { desc = 'Setup manual Docker clipboard bridge via shared /tmp' })
    
    -- Quick setup commands
    vim.api.nvim_create_user_command('QuickSetup', function(opts)
        local preset = opts.args or "essentials"
        
        print("[QUICK-SETUP] Setting up " .. preset .. " environment...")
        
        -- Install tools first
        if preset == "python" then
            python_env.setup()
        elseif preset == "full" then
            tool_manager.install_essentials()
            deps.install("core")
            deps.install("languages") 
            deps.install("tools")
            python_env.setup()
        else
            if tool_manager.presets[preset] then
                tool_manager.install_preset(preset)
            else
                tool_manager.install_essentials()
            end
        end
        
        print("[QUICK-SETUP] Setup completed for " .. preset)
    end, {
        nargs = '?',
        complete = function() 
            return {"essentials", "python", "web_dev", "data_science", "latex", "minimal", "full"}
        end,
        desc = 'Quick setup for common environments'
    })
end

return M