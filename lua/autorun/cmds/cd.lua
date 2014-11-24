--[[
	Change directory
	Credits to Lapin https://github.com/ExtReMLapin/GTerm

]]

local function pastfolder()  -- from ./garrysmod/lua/ to ./garrysmod/
	local tblspl = string.Explode("/", Term.Path) --Split the 
		table.remove(tblspl) --Pop off last key
		table.remove(tblspl) --And again
		Term.Path = table.concat(tblspl, "/") .. "/" or "" --Join the table to a string
		if Term.Path == "/" then Term.Path = "" end --If the path is nothing but a / it makes problems for us.
													--This simply turns it into nothing so it gets the base directory.

	pathtext = LocalPlayer():Nick() .. "@gmod: ~ " .. Term.Path .. " $" --We need to set the new prompt text
	drawpath:SetText(pathtext) --As well as update the label--
	drawpath:SizeToContents() --------------------------------
	commandbox:SetSize(frame:GetWide() - (4 + drawpath:GetWide()), 20) ------And resize the command box---
	commandbox:SetPos(drawpath:GetWide() + 2, frame:GetTall() - 22)---------------------------------------
	textarea:SetCaretPos(#textarea:GetValue()) --And set the caret to the end of the textbox.

	return
end

local function pathsanitise(text) -- remove last / 
	if string.sub( text, -1 ) == "/" then --If the last letter of the string is a slash, remove it.
		return string.sub( text, 1, -2 )
	end
	return text --Return the text.
end

function Term.cd(location) -- cd function. Parameter is as the name states, the location.
	Term.pathfixmultipleslash() --Fix the path if it is broken.
	if not location or #location == 0 then Term.error("No path specified!") return end --If there is no location specified then return
	text = location --Text = location
	text = pathsanitise(text) --Text is now equal to the output of pathsanatise

	if text != "" then --If text is not empty
		if text[1] == "."  and Term.Path == "" then return end  --If the first letter of the location is . then that means it is the 
																--current location. So we do not need to do anything.
		if text == ".." then --If text is .. then 
			pastfolder() --We need to go back a folder.
			return --Return because we don't need to do anything else in this function.
		end
		if (file.IsDir(Term.Path .. text .. "/", "BASE_PATH")) then --If the file is a directory
			Term.Path = Term.Path .. text .. "/" --Set the new path
		end

		--This is used if the user is targeting a directory that is in the folder below them.
		if string.Left(text, 3) == "../" and #location > 3 then --If the first three characters are "../" and location is greater than 3
			pastfolder() --We need to go backa folder
			if (file.IsDir(Term.Path ..string.Right(text, #location - 3) .. "/", "BASE_PATH")) then --And now we are back a folder we go
				Term.Path = Term.Path .. string.Right(text, #location - 3) .. "/" --Into the new folder
			end
		end
	end
	pathtext = LocalPlayer():Nick() .. "@gmod: ~ " .. Term.Path .. " $" --Set the new prompt text.
	drawpath:SetText(pathtext) -- Update the prompt label--
	drawpath:SizeToContents() -----------------------------
	commandbox:SetSize(frame:GetWide() - (4 + drawpath:GetWide()), 20)  --Set the size and position of the command text box--
	commandbox:SetPos(drawpath:GetWide() + 2, frame:GetTall() - 22)		-----------------------------------------------------
	textarea:SetCaretPos(#textarea:GetValue()) --Set the caret to the end of the text area.

end
