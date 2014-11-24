--[[
	Catenate
	This does not have full functionality due to limitations of Garrysmod.
]]
function Term.cat(file, options) --We pass in the options and the file here.
	Term.pathfixmultipleslash() --Fix directory if it is broken

	function cat_to_ascii(str) --Turn a string into an array of ascii codes
		if !Term.file_exists(str) then return end --If the file does not exist don't do this.
		local text = file.Read(str, "BASE_PATH") --Set text
		local text = string.Explode("", text) --break the text up into a table. Each letter is a element in the table.
		local ascii = {} --Ascii values for letter will go here.
		for k, v in pairs(text) do --For each letter in text
			table.insert(ascii, string.byte(v)) --Turn it to ascii
		end
		return ascii, text
	end

	if file and !options then --If the file is sent through but the option isn't do this. Here we print the file with no options.
		--Not exactly the best way to do it. But ghetto always works.
		--If there is one argument it will either be help or to read
		--A file.

		local file_path = tostring(Term.Path)
		local file_name = tostring(file)
		local tocat = file_path .. file_name

		if file == "--help" or file == "-h" then --If the option is --help or -h print the help
			textarea:SetValue(textarea:GetValue() .. [[Cat Help:
			Usage:
			 cat FILE        | View the contents of a file.
			 cat OPTION FILE | View the contents of a file modified by an option.

			Options:
			 -n              | Print line numbers.
			 -b              | Print line numbers on all non blank lines.
			 -A              | Print end of line characters as "$" and tabs as "^I".
			 -T              | Print tabs as "^I".
			 -E              | Print end of line characters as "$"

			 More features to come in the future.
			 ]])

		else --Otherwise it will just print a file.
			if file_name[-1] == "*" then --If the last character of the file string is * then
				local files, dirs = file.Find(tocat, "BASE_PATH") --Get every file name in the specified directory
				for k, v in pairs(files) do --For each file
					local loc = string.sub(tocat, 1, -2) --Remove the * from the path
					local file_name = loc..v --Append the file name to the path
					if !Term.file_exists(file_name) then Term.alert("File does not exist.") return end --Check if the file exists. If it doesn't display an error
					cat_without_options(file_name) --View the cat_without_options function below.
				end
			else --If the last character is not * just do this.
				if !Term.file_exists(tocat) then Term.alert("File does not exist.") return end --Check if the file exists. If it doesn't display an error
				cat_without_options(tocat) --view function below
			end
		end
	end

	-- If the option parameter is present do this
	if options then
		local file_path = tostring(Term.Path) 
		local file_name = tostring(file)
		local tocat = file_path .. file_name
		
		if file_name[-1] == "*" then --If the last letter of string is *
			local files, dirs = file.Find(tocat, "BASE_PATH") --Get every file and folder in the directory
			for k, v in pairs(files) do --For each file
				local loc = string.sub(tocat, 1, -2) --Remove the * from the string
				local file_name = loc..v
				if !Term.file_exists(file_name) then Term.alert("File does not exist.") return end --Check if the file exists. If it doesn't display an error
				cat_with_options(file_name, option) --View the cat_with_options function below
			end
		else --If it is just a normal file
			if !Term.file_exists(tocat) then Term.alert("File does not exist.") return end --Check if the file exists. If it doesn't display an error
			cat_with_options(tocat, option) --Print normally
		end
	end
end

--This function is for printing a file normally, without options.
function cat_without_options(f)
	textarea:SetValue(textarea:GetValue() .. file.Read(f, "BASE_PATH")  .. "\n")
end

--This function is for printing a file with a specified option.
function cat_with_options(f, op)
	local text = file.Read(f, "BASE_PATH") --Text is the contents of the file specified in arg 2.
	local lines = string.Explode("\n", text) --Break the file into a table. Each item in the table will be a line from the file.

	-- -n (--number) print with line numbers
	if op == "-n" then --If the first argument is -n
			for k, v in pairs(lines) do --For every line of the file
				textarea:SetValue(textarea:GetValue() .. k .. " " .. v .. "\n")
			end
	elseif op == "-b" then -- -b (--number-nonblank) Numbers all non blank lines
			local current_line = 1 --Current line is 1.
			for k, v in pairs(lines) do --For each line
				if v == "" or string.byte(v, 1) == 13 then -- If it is blank 
					textarea:SetValue(textarea:GetValue() .. "\n")
				else --If it is not blank.
					textarea:SetValue(textarea:GetValue() .. current_line .. " " .. v .. "\n")
					current_line = current_line + 1 -- Add one to the current line.
				end
			end
	elseif op == "-A" or op == "-T" or op == "-E" then -- Print all characters. ^I for tab and $ for end of line
		--There is a better way to do this but I couldn't think of anything.
		local ascii, text = cat_to_ascii(f)

			for k, v in pairs(ascii) do --For each item in ascii
				if v == 9 then --If it is a tab
					if op == "-A" or op == "-T" then --If the option is -A or -T do this
						text[k] = "^I" --Set the value in the text table to be ^I
					end
				elseif v == 13 then -- If it is an end of line character
					if op == "-A" or op == "-E" then --If the option is -A or -E do this
						text[k] = "$" --Change it to $
					end
				end
			end
			textarea:SetValue(textarea:GetValue() .. table.concat(text) .. "\n")
			
	else
		Term.alert("Invalid option '" .. op .. "' Try 'cat --help for more information.'") -- Print an error
	end
end
