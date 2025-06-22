-- Progress Display Utility Module
local M = {}

-- Create a progress bar
function M.bar(current, total, width)
    width = width or 20
    local progress = math.floor((current / total) * width)
    local filled = string.rep("█", progress)
    local empty = string.rep("░", width - progress)
    local percent = math.floor((current / total) * 100)
    return string.format("[%s%s] %d%%", filled, empty, percent)
end

-- Animated progress indicator
function M.spinner(message, duration)
    local frames = {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
    local start_time = os.time()
    local frame_index = 1
    
    while os.time() - start_time < duration do
        local spinner_char = frames[frame_index]
        print(string.format("\r%s %s", spinner_char, message))
        vim.cmd("redraw")
        
        frame_index = frame_index % #frames + 1
        os.execute("sleep 0.1")
    end
    
    print("\r✅ " .. message .. " - Completed!")
end

-- Installation header
function M.install_header(title, details)
    print("═" .. string.rep("═", 60))
    print("🚀 " .. title)
    print("═" .. string.rep("═", 60))
    if details then
        for key, value in pairs(details) do
            print(string.format("   %s: %s", key, value))
        end
        print("")
    end
end

-- Installation summary
function M.install_summary(title, stats)
    print("═" .. string.rep("═", 60))
    print("📊 " .. title .. " Summary:")
    print("═" .. string.rep("═", 60))
    
    for key, value in pairs(stats) do
        if key:match("success") or key:match("installed") then
            print(string.format("  ✅ %s: %s", key, value))
        elseif key:match("fail") or key:match("error") then
            print(string.format("  ❌ %s: %s", key, value))
        else
            print(string.format("  📈 %s: %s", key, value))
        end
    end
    
    print("═" .. string.rep("═", 60))
end

-- Package list display
function M.package_list(title, packages, status_map)
    print("📦 " .. title .. ":")
    print("─" .. string.rep("─", 50))
    
    for i, pkg in ipairs(packages) do
        local status = ""
        if status_map and status_map[pkg] ~= nil then
            status = status_map[pkg] and " ✅" or " ❌"
        else
            status = " 📥"
        end
        print(string.format("  %2d. %s%s", i, pkg, status))
    end
    
    print("")
end

-- Error display
function M.error_display(title, error_msg, suggestions)
    print("❌ " .. title)
    print("─" .. string.rep("─", 50))
    print("Error details:")
    print("  " .. error_msg:gsub("\n", "\n  "))
    
    if suggestions and #suggestions > 0 then
        print("\n💡 Suggestions:")
        for i, suggestion in ipairs(suggestions) do
            print(string.format("  %d. %s", i, suggestion))
        end
    end
    print("")
end

-- Time formatter
function M.format_time(seconds)
    if seconds < 60 then
        return string.format("%ds", seconds)
    elseif seconds < 3600 then
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%dm %ds", mins, secs)
    else
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        return string.format("%dh %dm", hours, mins)
    end
end

-- Installation step tracker
function M.step_tracker(current_step, total_steps, step_name)
    local progress = M.bar(current_step, total_steps, 15)
    print(string.format("🔄 Step %d/%d %s - %s", current_step, total_steps, progress, step_name))
end

-- Success celebration
function M.celebrate(message)
    local celebrations = {
        "🎉 " .. message .. " completed successfully! 🎉",
        "✨ " .. message .. " finished! ✨", 
        "🚀 " .. message .. " done! 🚀",
        "🎯 " .. message .. " successful! 🎯"
    }
    
    local celebration = celebrations[math.random(#celebrations)]
    print(celebration)
end

-- Warning display
function M.warning(message, details)
    print("⚠️  WARNING: " .. message)
    if details then
        print("   Details: " .. details)
    end
end

-- Info display
function M.info(message)
    print("ℹ️  " .. message)
end

-- Section divider
function M.section(title)
    print("\n" .. "▶ " .. title)
    print("─" .. string.rep("─", #title + 2))
end

return M