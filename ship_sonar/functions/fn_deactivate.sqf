#include "common.hpp"

// Deactivates the thing: deletes the panel, etc

// Bail if already active
if (!FLS_active) exitWith {};

// Delete the panel
private _panel = uiNamespace getVariable "FLS_panelGroup";
[_panel] call FLS_fnc_ui_panelDelete;

// Reset the flag so it doesn't get updated any more
FLS_active = false;