-- Convert a lua object to a lua-parsable string that can be loaded back in later

SaveFile = {}
function SaveFile.toString(contents)
    if type(contents) == "string" then
        return '"'..contents..'"'
    end
    if type(contents) == "number" then
        return contents
    end
    local output = {}
    for k, v in pairs(contents) do
        if type(v) == "function" then
            goto skip
        end
        if type(k) == "number" then
            output[#output + 1] = SaveFile.toString(v)
        else
            output[#output + 1] = k.."="..SaveFile.toString(v)
        end
        ::skip::
    end
    return "{"..table.concat(output, ", ").."}"
end

function SaveFile.save(obj, filename)
    local file = io.open(filename, "w+")
    file:write("level="..SaveFile.toString(obj))
    file:close()
end