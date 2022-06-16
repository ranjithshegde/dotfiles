local signature = {}

local triggers_by_buf = {}

local function generate_signature_help_autocmd(bufnr, client)
    local client_id = client.id
    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = vim.api.nvim_create_augroup("lsp_signature_help_" .. client_id .. "_" .. bufnr, { clear = true }),
        buffer = bufnr,
        callback = function()
            require("lsp.signature")._TriggerCharEvent(client_id)
        end,
    })
end

local function generate_signature_snippet_autocmd(bufnr, client)
    local client_id = client.id
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("lsp_signature_help_" .. client_id .. "_" .. bufnr, { clear = true }),
        pattern = { "n:v", "i:v" },
        callback = function()
            if package.loaded.luasnip then
                if require("luasnip").in_snippet() then
                    vim.schedule(vim.lsp.buf.signature_help)
                end
            end
        end,
    })
end

function signature._TriggerCharEvent()
    local char = vim.api.nvim_get_vvar "char"
    local triggers = triggers_by_buf[vim.api.nvim_get_current_buf()] or {}
    for _, entry in pairs(triggers) do
        local chars, fn = unpack(entry)
        if vim.tbl_contains(chars, char) then
            vim.schedule(fn)
            return
        end
    end
end

function signature.attach(client, bufnr)
    local triggers = triggers_by_buf[bufnr]
    if not triggers then
        triggers = {}
        triggers_by_buf[bufnr] = triggers
    end

    local signature_triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

    if signature_triggers and #signature_triggers > 0 then
        table.insert(triggers, { signature_triggers, vim.lsp.buf.signature_help })
    end

    generate_signature_help_autocmd(bufnr, client)
    generate_signature_snippet_autocmd(bufnr, client)
end

return signature
