
if (get_window_role()=="_desktop_terminal") then
	undecorate_window()
	set_window_below()
	maximize()
	center()
	set_skip_tasklist(true)
	set_skip_pager(true)
	pin_window()
	stick_window()
	set_window_type("_NET_WM_WINDOW_TYPE_DESKTOP")
end
