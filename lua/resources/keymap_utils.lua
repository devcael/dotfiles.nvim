local M = {}
local config = {
    baseSequence = "<C-S-A-F12>",
}
M.setup = function(opts)
    opts = opts or {}
    vim.tbl_extend("force", config, opts)
end
local replacements = {
    ["1"] = "q",
    ["2"] = "w",
    ["3"] = "e",
    ["4"] = "r",
    ["5"] = "t",
    ["6"] = "y",
    ["7"] = "u",
    ["8"] = "i",
    ["9"] = "o",
    ["0"] = "p",
}
M.mapNum = function(keysString)
    local str = ""
    for i = 1, #keysString do
        local prevPrevChar = i > 2 and keysString:sub(i - 2, i - 2) or nil

        local prevChar = i > 1 and keysString:sub(i - 1, i - 1) or nil
        local char = keysString:sub(i, i)
        local isNumber = tonumber(char) ~= nil
        local prevIsNumber = prevChar ~= nil and tonumber(prevChar) ~= nil
        local prevIsAllowed = prevChar == nil or prevChar ~= "F" or prevIsNumber
        local prevPrevIsAllowed = prevPrevChar == nil or prevPrevChar ~= "F"
        if isNumber and prevIsAllowed and prevPrevIsAllowed then
            str = str .. replacements[char]
        else
            str = str .. char
        end
    end
    return config.baseSequence .. str
end

return M
