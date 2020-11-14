#include "common.hpp"

// Sets sonar mode

params [["_newMode", "basic", [""]]];

if (FLS_active && _newMode != FLS_mode) then {
    [_newMode] call FLS_fnc_createPanelForMode;
};

FLS_mode = _newMode;