diag_log format ["FLS: Add action to player: %1", player];

player addAction
    [
        "Sonar Options",	// title
        {
            call FLS_fnc_ui_createSettingsPanel;
        },
        nil,		// arguments
        1.5,		// priority
        false,		// showWindow
        false,		// hideOnUse
        "",			// shortcut
        "true", 	// condition
        10,			// radius
        false,		// unconscious
        "",			// selection
        ""			// memoryPoint
    ];