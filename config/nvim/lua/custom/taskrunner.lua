local F = {}

function F.gitAddCommentAndPush(argCommand)

    vim.cmd(":Git add %")
    vim.cmd("!callterminal2count '%:p:h' gcpush '" .. argCommand .. "'")

end

function F.gitAddAllCommentAndPush(argCommand)

    vim.cmd("!callgitaddall '%:p:h'")      -- add all
    vim.cmd("!callterminal2count '%:p:h' gcpush '" .. argCommand .. "'")

end

return F
