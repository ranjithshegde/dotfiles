local signature = {}

local triggers_by_buf = {}

local id = {}
local au_sig, au_snip

local function generate_signature_help_autocmd(bufnr, client)
    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = id[au_sig],
        buffer = bufnr,
        callback = function()
            require("r.lsp.signature")._TriggerCharEvent(client.id)
        end,
        desc = "Trigger signature help on lsp-characters",
    })
end

local function generate_signature_snippet_autocmd()
    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "n:v", "i:v" },
        group = id[au_snip],
        callback = function()
            if package.loaded.luasnip then
                if require("luasnip").in_snippet() then
                    vim.schedule(vim.lsp.buf.signature_help)
                end
            end
        end,
        desc = "Trigger signature help in relevant luasnip nodes",
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

    au_sig = "lsp_signature_help_" .. client.id .. "_" .. bufnr
    id[au_sig] = vim.api.nvim_create_augroup(au_sig, { clear = true })

    au_snip = "lsp_signature_snip_" .. client.id .. "_" .. bufnr
    id[au_snip] = vim.api.nvim_create_augroup(au_snip, { clear = true })

    generate_signature_help_autocmd(bufnr, client)
    generate_signature_snippet_autocmd()

    require("r.utils").register_au_id(id)
end

return signature
