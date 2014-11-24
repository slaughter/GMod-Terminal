--[[
	Term Color
	Used to change the colors of the terminal.
]]

function Term.Colorize(colors)
	if colors[2] == "-background" then --Check if the option is -background
		if #colors >= 5 then --If there is less than 5 items in the array there is not enough to execute the command.
			Term.Colors['background'] = Color(colors[3], colors[4], colors[5]) --Change the background colour to the specified
		else --If there is less than 5 items 
			Term.alert("Type 'termcolor -help' for usage.") -- spit out an error
		end
	elseif colors[2] == "-textarea" then --Same for text area
		if #colors >= 5 then
			Term.Colors['textarea'] = Color(colors[3], colors[4], colors[5])
		else
			Term.alert("Type 'termcolor -help' for usage.")
		end
	elseif colors[2] == "-text" then --Same of text
		if #colors >= 5 then
			Term.Colors['consoletext'] = Color(colors[3], colors[4], colors[5])
			drawpath:SetTextColor(Color(colors[3], colors[4], colors[5])) --The label colour will not automatically update so we
			--Need to force it to reload.
		else
			Term.alert("Type 'termcolor -help' for usage.")
		end
	elseif colors[2] == "-titletext" then --Same for title text
		if #colors >= 5 then
			Term.Colors['titletext'] = Color(colors[3], colors[4], colors[5])
		else
			Term.alert("Type 'termcolor -help' for usage.")
		end
	elseif colors[2] == "-d" then --If the command is -d
		
		--Set all the colours back to default.
		Term.Colors = {
						titlefont = Color(0, 0, 0),
						background = Color(236, 236, 236),
						textarea = Color(0, 0, 0),
						consoletext = Color(200, 200, 200)
						}

		drawpath:SetTextColor(Term.Colors['consoletext']) --Reload the label colour.

	elseif colors[2] == "-h" or colors[2] == "-help" then --If the command is -help
		--Print out our help string. Anything between the the two square brackets is considered a string.
		textarea:SetValue(textarea:GetValue() .. [[
		To use term color type 'termcolor -identifier r g b'. Ex. termcolor -background 100 100 100
		
		Identifiers:
			-background | Frame background
			-textarea   | Text area colour.
			-text       | Change the colour of the text.
			-titletext  | Change the colour of the title.

		To reset to default use -d
			]])
	else --If none of the above.
		Term.alert("Type 'termcolor -help' for usage.") --Put out an error message.
	end

end