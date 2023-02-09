local navigator = {}

function navigator.config(native)
    if not native then
        return {
            lsp_signature_help = false,
            default_mapping = false,
            fold_ts = true,
            lsp = {
                format_on_save = false,
                enable = false,
                disable_lsp = 'all',
                hover = false,
            },
        }
    end

    return {
        fold_ts = true,
        default_mapping = false,
        lsp_signature_help = false,
        lsp = {
            format_on_save = false,
            servers = {},
            disable_lsp = { 'ccls' },
            hover = false,
            diagnostic = {
                all = false,
                virtual_text = false,
                underline = false,
                update_in_insert = false,
            },
        },
    }
end

function navigator.attach(client, bufnr)
    require('navigator.lspclient.mapping').setup {
        client = client,
        bufnr = bufnr,
        cap = client.server_capabilities,
    }
    require('navigator.dochighlight').documentHighlight(bufnr)
    require('navigator.codeAction').code_action_prompt(bufnr)
end

function navigator.init(cfg)
    if cfg and not vim.tbl_islist(cfg) then
        require('navigator').setup(cfg)
    else
        require('navigator').setup(navigator.config(false))
    end
end

return navigator
