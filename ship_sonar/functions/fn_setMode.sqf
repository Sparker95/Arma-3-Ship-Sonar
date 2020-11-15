#include "common.hpp"

// Sets sonar mode

params [["_newMode", "basic", [""]]];

// Update the color LUT
[_newMode] call FLS_fnc_updateColorLUT;

if (FLS_active && _newMode != FLS_mode) then {
    [_newMode] call FLS_fnc_createPanelForMode;

    // Reset timers
    FLS_pingTimer = 0;
    FLS_indicatorUpdateTimer = 0;
    FLS_scaleUpdateTimer = 0;
    FLS_nextScanlineID = 0;
};

FLS_mode = _newMode;