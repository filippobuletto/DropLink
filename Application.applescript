-- DropLink.applescript
-- DropLink

--  Created by Filippo B. on 25/03/11.
--  Copyright 2011-2014. The MIT License (MIT)

on idle
	(* Add any idle time processing here. *)
	show window "DropLink"
end idle

on open names
	-- localization
	set growlloc to ((localized string of "growlloc") as text)
	set dropinst to ((localized string of "dropinst") as text)
	set duplicated to ((localized string of "duplicated") as text)
	set like to ((localized string of "like") as text)
	set grazie to ((localized string of "grazie") as text)
	set problem to ((localized string of "problem") as text)
	set problem2 to ((localized string of "problem2") as text)
	set occured to ((localized string of "occured") as text)
	-- localization
	hide window "DropLink"
	try
		set dropdir to do shell script "cd " & (POSIX path of (path to me) as string) & "Contents/Resources; ./prefs.py;"
	on error
		display dialog dropinst with icon 2 buttons {"OK", "Cancel"} default button 2
		if the button returned of the result is "OK" then
			do shell script "open https://github.com/FilippoMito/DropLink"
		end if
	end try
	repeat with file_ in names
		tell application "Finder"
			set nome to name of file_
			set file_ to POSIX path of file_
			try
				set prova to dropdir & "/" & nome
				if exists prova as POSIX file then
					set rnd to {}
					repeat 8 times
						set rnd to rnd & some item of "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
					end repeat
					set nome to (rnd as string) & "_" & nome
					tell application "DropLink"
						display dialog duplicated default answer nome with icon 2 buttons {"OK", "Cancel"} default button 1
					end tell
					copy the result as list to {nome, button_pressed}
				end if
				do shell script "cd '" & dropdir & "'; ln -s " & quoted form of file_ & " '" & nome & "'"
				try
					tell application "GrowlHelperApp"
						register as application ¬
							"DropLink AppleScript" all notifications {"DropLink Notification"} ¬
							default notifications {"DropLink Notification"} ¬
							icon of application "DropLink"
						
						notify with name ¬
							"DropLink Notification" title ¬
							" " & growlloc description ¬
							"File: " & nome application name "DropLink AppleScript"
					end tell
				end try
			on error
				display dialog problem & nome & problem2 with title occured with icon 2 buttons {"OK", "Cancel"} default button 2
				if the button returned of the result is "OK" then
					do shell script "open https://github.com/FilippoMito/DropLink"
				end if
			end try
		end tell
	end repeat
	quit
end open


on will close theObject
	quit
end will close

on conclude drop theObject drag info dragInfo
	-- localization
	set growlloc to ((localized string of "growlloc") as text)
	set dropinst to ((localized string of "dropinst") as text)
	set duplicated to ((localized string of "duplicated") as text)
	set like to ((localized string of "like") as text)
	set grazie to ((localized string of "grazie") as text)
	set problem to ((localized string of "problem") as text)
	set problem2 to ((localized string of "problem2") as text)
	set occured to ((localized string of "occured") as text)
	-- localization
	tell application "DropLink" to activate
	set dropdir to ""
	try
		set dropdir to do shell script "cd " & (POSIX path of (path to me) as string) & "Contents/Resources; ./prefs.py;"
	on error
		display dialog dropinst with icon 2 buttons {"OK", "Cancel"} default button 2
		if the button returned of the result is "OK" then
			do shell script "open https://github.com/FilippoMito/DropLink"
			quit
		end if
	end try
	try
		set dropdir to (choose folder default location dropdir) as string
		set dropdir to POSIX path of dropdir
	on error
		quit
	end try
	if "file names" is in (get types of pasteboard of dragInfo) then
		set preferred type of pasteboard of dragInfo to "file names"
		repeat with thisFile in (get contents of pasteboard of dragInfo)
			set file_ to (POSIX file thisFile) as alias
			set text item delimiters to "/"
			set _file to (POSIX path of file_) as string
			if (the last character of _file is "/") then
				set nome to (text 1 thru ((length of _file) - 1)) of _file as string
			else
				set nome to _file as string
			end if
			set nome to last text item of nome
			
			set text item delimiters to ""
			--display dialog nome
			try
				set prova to dropdir & nome
				set res to do shell script "if [ -e \"" & prova & "\" ]
then
echo yes
fi"
				if (res contains "yes") then
					set rnd to {}
					repeat 8 times
						set rnd to rnd & some item of "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
					end repeat
					set nome to (rnd as string) & "_" & nome
					tell application "DropLink"
						display dialog duplicated default answer nome with icon 2 buttons {"OK", "Cancel"} default button 1
					end tell
					copy the result as list to {nome, button_pressed}
				end if
				do shell script "cd '" & dropdir & "'; ln -s " & quoted form of _file & " '" & nome & "'"
				try
					tell application "GrowlHelperApp"
						register as application ¬
							"DropLink AppleScript" all notifications {"DropLink Notification"} ¬
							default notifications {"DropLink Notification"} ¬
							icon of application "DropLink"
						
						notify with name ¬
							"DropLink Notification" title ¬
							" " & growlloc description ¬
							"File: " & nome application name "DropLink AppleScript"
					end tell
				end try
			on error
				display dialog problem & nome & problem2 with icon 2 buttons {"OK", "Cancel"} default button 2
				if the button returned of the result is "OK" then
					do shell script "open https://github.com/FilippoMito/DropLink"
				end if
			end try
		end repeat
	end if
end conclude drop