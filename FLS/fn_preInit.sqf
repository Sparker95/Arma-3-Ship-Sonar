// Called before mission start

// Initialize variables
FLS_active = false;
FLS_pingTimer = 0;
FLS_indicatorUpdateTimer = 0;
FLS_scaleUpdateTimer = 0;
FLS_lastScanData = [];
FLS_lastDepth = 0;
FLS_graphRefreshGrid = false;
FLS_graphRefreshPlot = false;

// Add per frame handler to update device
FLS_PFHID = addMissionEventHandler ["EachFrame", {
    call FLS_fnc_onEachFrame;
}];
