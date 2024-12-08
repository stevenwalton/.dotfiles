require("full-border"):setup() --  {
--     -- Allowed: ui.Border.PLAIN, ui.Border.ROUNDED
--     type = ui.Border.ROUNDED
--}

-- Set displayformat for the linemode (from yazi.toml)
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.modified or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end

-- require("mime-ext"):setup {
--  Left commented because we can modify but I haven't
-- }

-- Show sym link info in status bar
function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line {}
	end

	return ui.Line(" " .. h.name)
end

-- Username and host name in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line {}
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)
