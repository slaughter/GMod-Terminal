--[[
	Echo
	This does not have full functionality due to limitations of Garrysmod.
]]

function Term.echo(string)
	table.remove(string, 1) --Remove the "echo" part of the commands table
	to_echo = "" 
	for k, v in pairs(string) do --Join it all together with a space in between.
		to_echo = to_echo .. v .. " " --Add the word to to_echo with a space on the end.
	end
	textarea:SetValue(textarea:GetValue() .. to_echo) --Set the value of the text area to the already existing value + specified text.
	textarea:SetCaretPos(#textarea:GetValue()) --Set the caret to the end of the text box
end