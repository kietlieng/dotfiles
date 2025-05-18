-- Surround selections, add quotes, etc.
return {
    {

        --     Old text                    Command         New text
        -- --------------------------------------------------------------------------------
        --     surr*ound_words             ysiw)           (surround_words)
        --     *make strings               ys$"            "make strings"
        --     [delete ar*ound me!]        ds]             delete around me!
        --     remove <b>HTML t*ags</b>    dst             remove HTML tags
        --     'change quot*es'            cs'"            "change quotes"
        --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        --     delete(functi*on calls)     dsf             function calls

        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {

            keymaps = {
                insert = false,
                insert_line = false,
                visual_line = false,
                normal = 'yz',
                normal_cur = 'yzz',
                normal_line = 'yZ',
                normal_cur_line = 'yZZ',
                visual = 'Z',
            },

        },
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
}
