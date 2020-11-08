diag_log format ["FLS: Add action to player: %1", player];

player addAction
    [
        "Toggle Sonar",	// title
        {
            call FLS_fnc_actionToggle;
        },
        nil,		// arguments
        1.5,		// priority
        false,		// showWindow
        false,		// hideOnUse
        "",			// shortcut
        "vehicle player isKindOf 'Ship_F'", 	// condition
        10,			// radius
        false,		// unconscious
        "",			// selection
        ""			// memoryPoint
    ];