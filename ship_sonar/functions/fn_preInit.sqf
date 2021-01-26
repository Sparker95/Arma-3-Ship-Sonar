// Called before mission start

// Bail if weh ave no interface
if (!hasInterface) exitWith {};

// Initialize variables
FLS_active = false;
FLS_mode = "basic";
FLS_modes = ["basic", "sectorImage", "sectorDepth"];
FLS_modeNames = ["Basic Forward", "Sector Image", "Sector Depth"]; // Must match to FLS_modes
FLS_pingTimer = 0;
FLS_indicatorUpdateTimer = 0;
FLS_scaleUpdateTimer = 0;
FLS_lastScanData = [];
FLS_lastDepth = 0;
FLS_graphRefreshGrid = false;
FLS_graphRefreshPlot = false;
FLS_nextScanlineID = 0;
FLS_range = 100;
[FLS_range] call FLS_fnc_setRange;
FLS_rangeOptions = [20, 50, 100, 200, 400];
FLS_maxDepthOptions = [-1, 2, 4, 10, 20, 40, 100]; // -1 means auto
FLS_maxDepthUser = -1; // Option selected by user
FLS_maxDepth = 4; // Actual internal value used for calculations
FLS_pingInterval = 0.1;
FLS_forceRefreshGrid = false;
FLS_gammaOptions = [1, 1.5, 2.0, 2.5, 3];
FLS_gamma = 1.5;
FLS_colorLutSize = 128; // Should be enough?
FLS_colorLut = [[0,0,0,1], [1,1,1,1]]; // Will be recalculated anyway
FLS_scanSpeed = 100; // In percents
FLS_scanSpeedOptions = [25, 50, 100, 150, 200];

uiNamespace setVariable ["FLS_settingsDisplay", displayNull];

// Initialize display
"FLS_layer" cutRsc ["RscTitleDisplayEmpty", "PLAIN"];
private _display = uiNamespace getVariable "RscTitleDisplayEmpty";
uiNamespace setVariable ["FLS_layerDisplay", _display];

// Add per frame handler to update device
FLS_PFHID = addMissionEventHandler ["EachFrame", {
    call FLS_fnc_onEachFrame;
}];

// Recalculate look-up table for color
call FLS_fnc_updateColorLUT;

// Prepare vectors

// Array with end positions of vectors for generating ray casts
// We pre-compute them for performance reasons, because we need them to be
// somewhat randomized
private _positionsEndLocalArray = [];
private _beamWidth = 4;
private _angleStart = 0;
private _angleEnd = 90;
private _angles = [];
private _angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _angleIncrement = (10*((sin _angle)^2) max 0.1);
    _angle = _angle + _angleIncrement;
    _angles pushBack _angle;
};
for "_i" from 0 to 200 do {
    private _positionsEndLocal = _angles apply 
    {
        private _angle = _x;
        private _angleRandomized = _angle + random [-_beamWidth/2, 0, _beamWidth/2];
        private _randomDir = random [-_beamWidth/2, 0, _beamWidth/2];
        private _vecFwdLocal = [sin (_randomDir), cos (_randomDir), 0];
        private _posEndLocal = (_vecFwdLocal vectorMultiply ((cos _angleRandomized)));
        _posEndLocal = _posEndLocal vectorAdd ([0, 0, 1] vectorMultiply (-(sin _angleRandomized)));
        [_angle, _posEndLocal];
    };
    _positionsEndLocalArray pushBack _positionsEndLocal;
};
FLS_positionsEndLocal_basicFLS = _positionsEndLocalArray;


// Vectors for sector scanner
_positionsEndLocalArray = [];
_beamWidth = 0.8;
_angleStart = 3;
_angleEnd = 60;
_angles = [];
_angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _angleIncrement = (10*((sin _angle)^2) max 0.1) min 2;
    _angle = _angle + _angleIncrement;
    _angles pushBack _angle;
};
for "_i" from 0 to 200 do {
    private _positionsEndLocal = _angles apply 
    {
        private _angle = _x;
        private _angleRandomized = _angle + random [-_beamWidth/2, 0, _beamWidth/2];
        private _randomDir = random [-_beamWidth/2, 0, _beamWidth/2];
        private _vecFwdLocal = [sin (_randomDir), cos (_randomDir), 0];
        private _posEndLocal = (_vecFwdLocal vectorMultiply ((cos _angleRandomized)));
        _posEndLocal = _posEndLocal vectorAdd ([0, 0, 1] vectorMultiply (-(sin _angleRandomized)));
        [_angle, _posEndLocal];
    };
    _positionsEndLocalArray pushBack _positionsEndLocal;
};
FLS_positionsEndLocal_sector = _positionsEndLocalArray;


// Vectors for sector depth sonar
_positionsEndLocalArray = [];
_beamWidth = 4;
_angleStart = 0;
_angleEnd = 60;
_angles = [];
_angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _angleIncrement = (10*((sin _angle)^2) max 0.1) min 2;
    _angle = _angle + _angleIncrement;
    _angles pushBack _angle;
};
for "_i" from 0 to 200 do {
    private _positionsEndLocal = _angles apply 
    {
        private _angle = _x;
        private _angleRandomized = _angle + random [-_beamWidth/2, 0, _beamWidth/2];
        private _randomDir = random [-_beamWidth/2, 0, _beamWidth/2];
        private _vecFwdLocal = [sin (_randomDir), cos (_randomDir), 0];
        private _posEndLocal = (_vecFwdLocal vectorMultiply ((cos _angleRandomized)));
        _posEndLocal = _posEndLocal vectorAdd ([0, 0, 1] vectorMultiply (-(sin _angleRandomized)));
        [_angle, _posEndLocal];
    };
    _positionsEndLocalArray pushBack _positionsEndLocal;
};
FLS_positionsEndLocal_sectorDepth = _positionsEndLocalArray;