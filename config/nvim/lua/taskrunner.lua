local F = {}

function F.gitAddCommentAndPush(argCommand)

    vim.cmd(":Git add %")
    vim.cmd("!callterminal2count '%:p:h' gcpush '" .. argCommand .. "'")

end

return F
