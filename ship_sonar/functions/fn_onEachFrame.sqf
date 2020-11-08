#include "common.hpp"

// Called on each frame

if (FLS_active) then {
    // Deactivate if player isn't in a boat any more
    if (!((vehicle player) isKindOf "Ship_F")) then {
        call FLS_fnc_deactivate;
    } else {
        // Update if active
        call FLS_fnc_update;
    };
};


// Add action to player if he doesn't have it
private _added = player getVariable ["FLS_toggleActionAdded", false];
if (!_added) then {
    _actionID = call FLS_fnc_addActionToggle;
    player setVariable ["FLS_toggleActionAdded", true];
    player addEventHandler ["Respawn", { player setVariable ["FLS_toggleActionAdded",false]; }];
};