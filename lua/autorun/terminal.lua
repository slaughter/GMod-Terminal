--[[
	Terminal Client by fghdx
	Inspired by GTerm https://github.com/ExtReMLapin/GTerm
	cd, pwd and ls are thanks to him.

	Check out this project on github:
	https://github.com/fghdx/GMod-Terminal/

]]--

Term = {}
Term.Path = ""
Term.Text = ""
Term.DefaultText = [[Gmod Terminal v1
Open source at https://github.com/fghdx/GMod-Terminal/
Credit to ExtReMLapin for some code. Check out his project: https://github.com/ExtReMLapin/GTerm]]

Term.LastCommand = ""

Term.Colors = {
				titlefont = Color(0, 0, 0),
				background = Color(236, 236, 236),
				textarea = Color(0, 0, 0),
				consoletext = Color(200, 200, 200)
			}




--Global functions
function Term.space( times )
	return string.rep( " ", times ) --Used to create spacing for messages.
end

function Term.alert(message)
	textarea:SetValue(textarea:GetValue() .. "Error: " .. message .. "\n") 
end

function Term.pathfixmultipleslash()
	Term.Path = string.gsub(Term.Path, "//", "/") --If there are multiple slashes in the path this will remove the,
end

function Term.file_exists(f)
	if file.Exists(f, "BASE_PATH") then return true end --Check if the file exists.
end


--------------------------------
---- Including the commands ----
--------------------------------
include("cmds/cd.lua")	      --
include("cmds/ls.lua")	      --
include("cmds/pwd.lua")	      --
include("cmds/cat.lua")	      --
include("cmds/echo.lua")      --
include("cmds/termcolor.lua") --
--------------------------------
--------------------------------




if CLIENT then --We do not want to execute this on the server.

--fonts
surface.CreateFont("terminaltitle", {font="Myriad Pro", size=18, antialias=true}) --Title
surface.CreateFont("terminalfont", {font="ProFontWindows", size=12, antialias=true}) --Terminal font.

function Term.Menu() --Function for drawing the menu
	--The derma elements here are not local so we can access them outside of this function.

	frame = vgui.Create("DFrame") --Create the frame. This is where we will draw everything.
	frame:SetSize(650, 350) --Size
	frame:SetTitle("") --Title is set to nothing because we draw the title in the paint function.
	frame:ShowCloseButton(false) --We do not need a close button as I made a custom one below. (See frameclose function)
	frame:MakePopup() --Make the frame resease the mouse.
	function frame:Paint(w,h) --This function is so we can draw on the frame.
		draw.RoundedBox(0, 0, 0, w, h, Term.Colors['background']) --Changing the background colour.
		draw.RoundedBox(0, 2, 25, w - 4, h - 27, Term.Colors['textarea']) --Draw a area for text box.
		draw.SimpleText("Terminal", "terminaltitle", 5, 5, Term.Colors['titlefont']) --Draw the title.
	end

	textarea = vgui.Create("DTextEntry", frame) --Create the text area
	textarea:SetSize(frame:GetWide() - 4, frame:GetTall() - 47) --Set the size
	textarea:SetMultiline(true) --Multiple lines
	textarea:SetPos(2, 25) --Set pos
	textarea:SetEditable(true)  --I would prefer to have this false, but it is the only way to make the text area
								--highlightable / make the scroll bar work. If you know another way let me know.

	if Term.Text == "" then --If the text in the terminal is not already set
		textarea:SetText(Term.DefaultText) --Put the default text in
	else --Otherwise
		textarea:SetValue(Term.Text) --Put in the text that we saved
	end
	textarea:SetVerticalScrollbarEnabled(true) --So we can scroll.
	textarea:SetFont("terminalfont") --Setting the font to our terminal font.
	function textarea:Paint(w, h) --Lets theme the textarea
		draw.RoundedBox(0, 0, 0, w, h, Term.Colors['textarea']) --This is the background colour.
		textarea:DrawTextEntryText(Term.Colors['consoletext'], Color(255, 255, 255), Color(200, 200, 200)) --This is the actual textbox.
		-- The parameters are (text color, highlight colour, cursor colour.)
	end

	
	pathtext = LocalPlayer():Nick() .. "@gmod: ~ " .. Term.Path .. " $" --This is the text for the prompt
																		--This will look like "fghdx@gmod ~ garrysmod/lua $"
	drawpath = vgui.Create("DLabel", frame) --Create the label for the prompt
	drawpath:SetText(pathtext) --Set the text for the prompt label
	drawpath:SetFont("terminalfont") --Set the font for the label
	drawpath:SetTextColor(Term.Colors['consoletext']) --Set the text folour for the label
	drawpath:SetPos(2, frame:GetTall() - 17) --Get the position for the label
	drawpath:SizeToContents() --Size the label to match the length of the text

	commandbox = vgui.Create("DTextEntry", frame) --Create the box for the command
	commandbox:SetSize(frame:GetWide() - (4 + drawpath:GetWide()), 20) --Set the size. It is 4 pixels in front of the prompt label
	commandbox:SetPos(drawpath:GetWide() + 2, frame:GetTall() - 22) --Set the position for the command textbox
	commandbox:RequestFocus() --This will make the text box focus upon opening the menu.
	function commandbox:OnKeyCodeTyped(code) -- Here we can sort out what happens on when certain keys are pressed.
		--View a list of the key enums here: http://wiki.garrysmod.com/page/Enums/KEY
		if code == 88 then --This is for the up arrow. We want this to display our last sent command. (We set this lower down)
			commandbox:SetText(Term.LastCommand) --Sets the command box text to the last sent command.
			commandbox:SetCaretPos(#commandbox:GetText()) --Set the caret to the end of the textbox.
		end
	
		if code == 64 then send_command() end --64 is the code for the enter key. This will execute the send_command() function below.
	end
	function commandbox:Paint(w, h) --Lets paint the command box
		draw.RoundedBox(0, 0, 0, w, h, Term.Colors['textarea']) --Set the background to the background colour
		commandbox:DrawTextEntryText(Term.Colors['consoletext'], Color(255, 255, 255), Color(200, 200, 200)) --Set the text colour, highlight
																											 --colour And cursor colour 
	end
	function send_command() --This is the function where the command is proccessed.

		--This prints the command when it is entered. Eg: "fghdx@gmod ~ $ cd garrysmod/lua"
		textarea:SetValue(textarea:GetValue() .. "\n" .. pathtext .. " " .. commandbox:GetValue() .. "\n")

		local command = string.Explode(" ", commandbox:GetValue())  --Create a table from the entered string.
																	--We can use this to identify the command and any parameters needed.
		
		--If you enter something like "cat -A file.lua" it will be exploded into
		--command[1] = cat
		--command[2] = -A
		--command[3] = file.lua

		if command[1] == "pwd" then --Check if the first word entered is pwd
			Term.pwd() --If it was execute the pwd function in cmds/pwd.lua
		end

		if command[1] == "clear" then --If the command entered is 'clear'
			textarea:SetValue("")	  --Remove all text from the textarea
		end

		if command[1] == "cd" then --If the command is cd
			if #command == 1 then return end -- If there is only one item in the list return. We need to pass through a file as a parameter.
			Term.cd(command[2]) --Execute the cd command in "cmds/cd.lua" passing through the file as the parameter.
		end

		if command[1] == "ls" then --If the command is ls
			Term.ls() --Execute the ls command in "cmds/ls.lua"
		end

		if command[1] == "echo" then --If the command is echo
			if #command == 1 then Term.error("You need to pass through a string.") end -- If there is only one item in the list chuck out an error.
			Term.echo(command)  --Execute the echo function is cmds/echo.lua
								--We send through the command table and deal with it in the echo function.
		end

		if command[1] == "exit" then --If the command is 'exit'
			frame:Remove() --Remove the frame.
			Term.Text = ""
			Term.Path = ""
			--We don't save the text of the session as we assume they want to completely exit and start a new window fresh.
		end

		if command[1] == "cat" then --If the command is cat
			if command[3] then --If there is a third parameter we want to pass in an option as well as the file.
				Term.cat(command[3], command[2]) --The first parameter is the file and the second is the option.
												 --The command is typically executed cat -option file
			else --If otherwise we just want to pass in the file.
				Term.cat(command[2]) --The second item in the array will be the file.
			end
		end

		if command[1] == "termcolor" then --If the command is termcolor
			Term.Colorize(command) --Send through the command table to the function
		end

		Term.LastCommand = commandbox:GetValue() --When the command is sent we save it as the last command so we can get it by pressing up.
		textarea:SetCaretPos(#textarea:GetValue()) --Set the caret pos so the text area is always at the bottom.
		commandbox:SetText("") --Remove the text in teh command box
		commandbox:RequestFocus() --Set the focus to the command box.

	end


	local frameclose = vgui.Create("DButton", frame) --This is our custom close button.
	frameclose:SetSize(35, 20) --Set the size to be appropriate.
	frameclose:SetPos(frame:GetWide() - 37, 0) --Set the pos
	frameclose:SetText("") --We don't want the text to be anything because we draw that below.
	frameclose.DoClick = function() --On click
		frame:Remove() --Remove the frame
		Term.Text = textarea:GetValue() --Set Term.Text to the textarea
	end

	function frameclose:Paint(w, h) --paint function for the button
		--This is a little different because we want the button to have a different look if it is pressed.
		if frameclose:IsDown() then --Check if the button is down
			--If it is we want to do this.
			draw.RoundedBox(0, 0, 2, w, h, Color(192, 57, 43))
			draw.SimpleText("x", "terminaltitle", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else --If it isn't we do this
			draw.RoundedBox(0, 0, 0, w, h, Color(239, 72, 54))
			draw.RoundedBox(0, 0, h-2, w, 2, Color(192, 57, 43))
			draw.SimpleText("x", "terminaltitle", w / 2, (h / 2) - 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	textarea:SetCaretPos(#textarea:GetValue()) --Set the caret to the end of the text area so we get put the the bottom the the textbox.

end
--Console Commands
concommand.Add("terminal", Term.Menu) --Add the console command.

end

