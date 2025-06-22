#!/usr/bin/env lua
local M = {}

-- Get environment config
local env_config = _G.nvim_env or {}

local function createImgDirIfNotExist(baseDir)
    if baseDir ~= "" then
        if vim.fn.finddir("img",baseDir) == "" then
            -- Use cross-platform directory creation
            vim.fn.mkdir(baseDir .. "/img", "p")
        end
        return baseDir .. "/img"
    end
end

-- Cross-platform screenshot function
local function getScreenshotCommand(outputPath)
    local os_type = (env_config.os) or vim.loop.os_uname().sysname:lower()
    
    if os_type:find("linux") then
        -- Try different screenshot tools in order of preference
        if vim.fn.executable("flameshot") == 1 then
            return string.format("flameshot gui --path %s", vim.fn.shellescape(outputPath))
        elseif vim.fn.executable("gnome-screenshot") == 1 then
            return string.format("gnome-screenshot -a -f %s", vim.fn.shellescape(outputPath))
        elseif vim.fn.executable("scrot") == 1 then
            return string.format("scrot -s %s", vim.fn.shellescape(outputPath))
        elseif vim.fn.executable("maim") == 1 then
            return string.format("maim -s %s", vim.fn.shellescape(outputPath))
        end
    elseif os_type:find("darwin") then
        -- macOS screenshot
        return string.format("screencapture -i %s", vim.fn.shellescape(outputPath))
    elseif os_type:find("windows") then
        -- Windows - note: this is limited, might need additional tools
        return string.format("snippingtool /clip")
    end
    
    return nil
end

M.takeScreenShot = function (fileName)
    if fileName == nil or fileName == "" then
        fileName = vim.fn.strftime("Y%y_M%m_D%d_H%H_M%M")
    end
    
    local imgBaseDir = createImgDirIfNotExist(vim.fn.getcwd())
    if imgBaseDir ~= nil then
        local fullPath = imgBaseDir .. "/" .. fileName .. ".png"
        local command = getScreenshotCommand(fullPath)
        
        if command then
            vim.fn.system(command)
            -- Check if file was created
            if vim.fn.filereadable(fullPath) == 1 then
                return fileName .. ".png"
            else
                vim.notify("Screenshot may not have been saved", vim.log.levels.WARN)
                return fileName .. ".png"
            end
        else
            vim.notify("No screenshot tool available. Please install flameshot, gnome-screenshot, scrot, or maim", vim.log.levels.ERROR)
            return nil
        end
    end
end

local find_baseDir_contains_file = function (contain_file)
    local mainFile = vim.fs.find(contain_file,{
        upward = true,
        stop = "/",
        path = vim.api.nvim_buf_get_name(0)
    })
    if #mainFile == 1 then
        return vim.fs.dirname(mainFile[1])
    else
        vim.notify("Cannot find parents folder contain " .. contain_file .. "!","error")
        return "/"
    end
end

local relative_path_from = function (curFile,baseDir)
    baseDir = vim.fs.normalize(baseDir)
    if #baseDir == 0 then
        return curFile
    end
    for dir in vim.fs.parents(curFile) do
        if dir == baseDir then
            return "." .. string.sub(curFile,#dir+1)
        end
    end
    vim.notify("Check screenshot/screenshot.lua.relative_path_from function","error")
    return ""
end

-- local cur = vim.fn.getcwd(0) .. "/img/" .. "test.png"
-- local base = find_baseDir_contains_file("main.tex")
-- local imgPath = relative_path_from(
--     cur,
--     base
-- )
-- print(imgPath)


M.latexTakeShotAndSave = function()
    local option = {
        prompt = "Image Name:",
    }
    local lineNum = vim.fn.line(".")
    vim.ui.input(option,function (input)
        local fileName = string.gsub(input,"%s+","_")
        if fileName ~= "" and fileName ~= nil then
            fileName = M.takeScreenShot((fileName))
            local imgPath = relative_path_from(
                vim.fn.getcwd(0) .. "/img/" .. fileName,
                find_baseDir_contains_file("main.tex")
            )
            local graph = {
                -- "\\end{figure}",
                "\t\\includegraphics[width=.95\\textwidth]{" .. imgPath .. "}",
                -- "\\begin{figure}[!htb]",
            }
            for i, line in ipairs(graph) do
                vim.fn.append(lineNum,line)
            end
        end
    end)
end

M.markdownTakeShotAndSave = function ()
    local option = {
        prompt = "Image Name:",
    }
    local lineNum = vim.fn.line(".")
    vim.ui.input(option,function (input)
        local fileName = string.gsub(input,"%s+","_")
        if fileName ~= "" and fileName ~= nil then
            local imgPath = "./img/" .. M.takeScreenShot(fileName)
            vim.fn.append(lineNum,"!["..fileName.."]".."("..imgPath..")")
        end
    end)
end
return M
