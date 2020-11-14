#include "common.hpp"

params [["_newMode", "basic", [""]]];

// Delete old panel
private _oldPanel = uins getv ["FLS_panelGroup", controlNull];
if (!isNull _oldPanel) then {
    [_oldPanel] call FLS_fnc_ui_panelDelete;
};

// Create new panel
private _display = uinamespace getvariable "FLS_layerDisplay";
switch (_newMode) do {
    case "basic": { [_display] call FLS_fnc_ui_panelCreate; };
    case "sectorImage": { [_display] call FLS_fnc_ui_panelPolarCreate; };
    case "sectorDepth": { [_display] call FLS_fnc_ui_panelPolarCreate; };
    default { diag_log format ["FLS: error: wrong mode: %1", _newMode]; };
};