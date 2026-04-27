local F = {}

function F.restore()

	-- Completely reload undo file from disk
	local file = vim.fn.expand('%:p')
	local undo_file = vim.fn.undofile(file)
	
	if vim.fn.filereadable(undo_file) ~= 1 then
		print('No undo file found')
		return
	end
	
	-- Clear current undo history
	vim.cmd('edit!')  -- Reload file
	
	-- Force reload undo file
	local ok, err = pcall(function()
		vim.cmd('rundo ' .. vim.fn.fnameescape(undo_file))
	end)
	
	if ok then
		print('Undo file reloaded')
		vim.cmd('undolist')
	else
		print('Error loading undo file: ' .. tostring(err))
	end

end

return F
