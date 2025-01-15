require("full-border"):setup() --  {
--     -- Allowed: ui.Border.PLAIN, ui.Border.ROUNDED
--     type = ui.Border.ROUNDED
--}

-- Set displayformat for the linemode (from yazi.toml)
function Linemode:size_and_mtime()
  -- https://github.com/sxyazi/yazi/issues/1772
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
  -- Add space here to give clearer separation from filename
	return ui.Line(string.format("  %s %s",
                               size and ya.readable_size(size) or "-",
                               time
                 )
  )
end

-- require("mime-ext"):setup {
--  Left commented because we can modify but I haven't
-- }

-- Override status function to add owner to the right side
Status._right = {
    { "owner", id = 4, order = 1000 },
    { "perm", id = 5, order = 2000 },
    { "percent", id = 6, order = 3000 },
    { "position", id = 7, order = 4000 },
}

-- Add Owner function
function Status:owner()
    local h = self._current.hovered
    if not h then
        return ""
    end

    local owner = ya.user_name(h.cha.uid) or tostring(h.cha.uid)
    local group = ya.group_name(h.cha.gid) or tostring(h.cha.gid)

    local spans = {
        ui.Span(" " .. owner):style(THEME.status.perm_read),
        ui.Span(":" .. group .. " "):style(THEME.status.perm_exec),
    }
    if not owner then
        spans[0] = ui.Span(" -"):style(THEME.status.perm_sep)
    end
    if not group then
        spans[1] = ui.Span(":- "):style(THEME.status.perm_sep)
    end
    return ui.Line(spans)
end

-- Override status name to show softlinks
-- Truncate link to link_truncation characters
function Status:name()
	local h = self._current.hovered
	if not h then
		return ""
	end

  local linked = ""
  local link_truncation = 50
  if h.link_to ~= nil then
      linked = " -> " .. tostring(h.link_to)
      if string.len(linked) > link_truncation then
          linked = string.sub(linked, 1,link_truncation)
          linked = linked .. "…"
      --    linked = linked .. "..."
      end
  end
  return " " .. h.name:gsub("\r", "?", 1) .. linked
end

-- Username and host name in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line {}
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

