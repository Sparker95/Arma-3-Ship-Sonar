#include "common.hpp"

// Activates the thing: creates the panel, etc

// Bail if already active
if (FLS_active) exitWith {};

// Reset the variables
FLS_pingTimer = 0;
FLS_indicatorUpdateTimer = 0;
FLS_scaleUpdateTimer = 0;
FLS_graphRefreshGrid = false;
FLS_graphRefreshPlot = false;

// Create the panel
[finddisplay 46] call FLS_fnc_ui_panelCreate;

// Set the flag so it gets updated
FLS_active = true;