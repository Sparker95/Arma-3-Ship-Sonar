params [["_power", false, [false]]];


if (_power) then {
    // Device should be activated
    if (!FLS_active) then {
        // Update the color LUT
        [FLS_mode] call FLS_fnc_updateColorLUT;
        
        // Create the panel
        [FLS_mode] call FLS_fnc_createPanelForMode;

        // Set the flag so it gets updated
        FLS_active = true;

        // Reset timers
        FLS_pingTimer = 0;
        FLS_indicatorUpdateTimer = 0;
        FLS_scaleUpdateTimer = 0;
        FLS_nextScanlineID = 0;
    };
} else {
    // Device should be deactivated
    if (FLS_active) then {
        // Delete the panel
        private _panel = uiNamespace getVariable ["FLS_panelGroup", controlNull];
        if (!isNull _panel) then {
            [_panel] call FLS_fnc_ui_panelDelete;
        };

        // Reset the flag so it doesn't get updated any more
        FLS_active = false;
    };
};

FLS_active = _power;