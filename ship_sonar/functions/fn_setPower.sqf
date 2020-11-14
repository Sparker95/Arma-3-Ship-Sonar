params [["_power", false, [false]]];


if (_power) then {
    // Device should be activated
    if (!FLS_active) then {
        // Create the panel
        [uinamespace getvariable "FLS_layerDisplay"] call FLS_fnc_ui_panelCreate;

        // Set the flag so it gets updated
        FLS_active = true;
    };
} else {
    // Device should be deactivated
    if (FLS_active) then {
        // Delete the panel
        private _panel = uiNamespace getVariable "FLS_panelGroup";
        [_panel] call FLS_fnc_ui_panelDelete;

        // Reset the flag so it doesn't get updated any more
        FLS_active = false;
    };
};



FLS_active = _power;