local M = {}

-- Process a single mapping entry and its value
local function process_mapping(key, value, options)
    if type(value) ~= 'table' then
        return nil
    end

    -- If it's a group
    if value.name then
        local group_mapping = {
            key,
            group = value.name,
        }

        if options then
            for k, v in pairs(options) do
                if group_mapping[k] == nil then
                    group_mapping[k] = v
                end
            end
        end

        return group_mapping
    end

    -- If it's a mapping with command/function
    if value[1] then
        local mapping = {
            key,
            value[1],
            desc = value[2],
        }

        -- Copy any additional options from the mapping itself
        for k, v in pairs(value) do
            if type(k) == 'string' and k ~= 'desc' then
                mapping[k] = v
            end
        end

        -- Add global options
        if options then
            for k, v in pairs(options) do
                if mapping[k] == nil then
                    mapping[k] = v
                end
            end
        end

        return mapping
    end

    return nil
end

-- Check if a table needs to be treated as a group even without a name
local function is_implicit_group(value)
    if type(value) ~= 'table' then
        return false
    end
    -- If it has any nested mappings, treat it as a group
    for _, v in pairs(value) do
        if type(v) == 'table' then
            return true
        end
    end
    return false
end

-- Convert mappings to the new format
function M.convert_maps(mappings, options)
    if type(mappings) ~= 'table' then
        return {}
    end

    local result = {}
    local queue = {}
    local seen = {} -- Track processed keys to prevent duplication

    -- Initialize queue with top-level mappings
    for k, v in pairs(mappings) do
        table.insert(queue, { key = k, value = v, prefix = '' })
    end

    -- Process queue
    while #queue > 0 do
        local item = table.remove(queue, 1)
        local full_key = item.prefix .. item.key

        -- Prevent duplicate processing
        if seen[full_key] then
            goto continue
        end
        seen[full_key] = true

        -- Process current item
        if is_implicit_group(item.value) and not item.value.name and not item.value[1] then
            -- Handle unnamed groups (like the ']' and '[' mappings)
            for subkey, subvalue in pairs(item.value) do
                local new_key = full_key .. subkey
                local mapping = process_mapping(new_key, subvalue, options)
                if mapping then
                    table.insert(result, mapping)
                else
                    table.insert(queue, {
                        key = subkey,
                        value = subvalue,
                        prefix = full_key,
                    })
                end
            end
        else
            local mapping = process_mapping(full_key, item.value, options)
            if mapping then
                table.insert(result, mapping)

                -- If it's a group, add its contents to the queue
                if item.value.name then
                    for subkey, subvalue in pairs(item.value) do
                        if subkey ~= 'name' then
                            table.insert(queue, {
                                key = subkey,
                                value = subvalue,
                                prefix = full_key,
                            })
                        end
                    end
                end
            end
        end

        ::continue::
    end

    return result
end

-- Backwards compatibility
M.convert_config = M.convert_maps

return M
