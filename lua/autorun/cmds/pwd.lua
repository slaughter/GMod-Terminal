--[[
	Print working directory
	Credits to Lapin https://github.com/ExtReMLapin/GTerm
]]

function Term.pwd() -- Print working directory
	Term.pathfixmultipleslash() --Fix the path
	local to_print = "./" .. Term.Path .. "\n" --Set a variable for the path.
	textarea:SetValue(textarea:GetValue() .. "\n" .. to_print) --Print the path to the text box.
	textarea:SetCaretPos(#textarea:GetValue()) --Set the caret.
end
