--[[
	listing
	Credits to Lapin https://github.com/ExtReMLapin/GTerm

]]


-----------
----LS-----
-----------

function Term.ls() -- print files infos and directories
	Term.pathfixmultipleslash()
	local maxsize = 0;
	local maxsize2 = 0;
	local tbl1, tbl2 = file.Find(Term.Path .. "*", "BASE_PATH")

	for k, v in pairs(tbl2) do -- For each folder print the formatted name to the text are.
		textarea:SetValue(textarea:GetValue() .. string.format("./%s/\n", v)) --%s is where the name goes.
		textarea:SetCaretPos(#textarea:GetValue()) --Set caret pos.
	end

	for k, v in pairs(tbl1) do -- Get the max length for file names
		if #v > maxsize then  -- If v has more letter than the old max set it as the new max.
			maxsize = #v
		end
	end

	for k, v in pairs(tbl1) do -- For each file in the folder
		if #tostring(file.Size(Term.Path .. v, "BASE_PATH")) > maxsize2 then  --Get the largest length of filesize. Just like the name.
			maxsize2 = #tostring(file.Size(Term.Path .. v, "BASE_PATH"))
		end
	end

	for k, v in pairs(tbl1) do --For each file
		local name_length = #v -- Name length
		local size_length =#tostring(file.Size(Term.Path .. v, "BASE_PATH")) --Length of size. (How many characters make up the string)
		size = file.Size(Term.Path .. v, "BASE_PATH") -- The actual size of the file.
		edited = os.date( "%d.%m.%y", file.Time(Term.Path .. v, "BASE_PATH")) --Date

		--Print file to the text area.
		textarea:SetValue(textarea:GetValue() .. v .. Term.space( maxsize - name_length ) .. " | Size: " .. size .. Term.space( maxsize2 - size_length ) .. " | Last edited: " .. edited .. "\n")
		textarea:SetCaretPos(#textarea:GetValue()) --Set caret pos.
	end

	end
