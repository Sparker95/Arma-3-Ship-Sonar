#include "common.hpp"

// Called on each frame

if (FLS_active && !isGamePaused) then {
    // Deactivate if player isn't in a boat any more
    if (!((vehicle player) isKindOf "Ship_F")) then {
        call FLS_fnc_deactivate;
    } else {
        // Update if active
        switch (FLS_mode) do {
            case "basic": { call FLS_fnc_updateBasicFLS; };
            case "sectorImage": { call FLS_fnc_updateSectorSonar; };
        };
    };
};


// Add action to player if he doesn't have it
private _added = player getVariable ["FLS_actionAdded", false];
if (!_added) then {
    _actionID = call FLS_fnc_addAction;
    player setVariable ["FLS_actionAdded", true];
    player addEventHandler ["Respawn", { player setVariable ["FLS_actionAdded",false]; }];
};