--duplicate lines and change the second line to == charecters
--:g/^\w/t.|s/./=/g
--
--double space every line pu (put text after the line)
--:g/^/pu =\"\n\"
--
--In order to double the number of spaces at the beginning of every line (and only at the beginning):
--:%s/^\s*/&&/g
--
--motions that you don't use often
--[count]]m ~ goes to the next function definition as in ]m
--[count]$ ~ moves to the count lines and places cursor at the end
--use f more to find characters
--
-- paste onto mark c
--:normal! 'cp``
--
--run command and output to current buffer
--%! <some command>
-- >>= Navigation =<<
-- buffer navigation
-- shortcuts


# to delete html tags.
-- qqda>@qq@qZZ
-- da> delete's tags
-- qq recorder with on key q
-- @qq call recorder q and stop recording (q)
-- @q call the macro that will repeat itself 
