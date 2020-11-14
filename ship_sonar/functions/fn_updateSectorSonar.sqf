private _pingInterval = 1/80;
private _scanDirStart = -70;
private _dirStep = 1;
private _nScanlines = 70*2 + 1;
private _veh = vehicle player;

private _graph = uiNamespace getVariable "FLS_graphPolarGroup";

FLS_pingTimer = FLS_pingTimer + diag_deltaTime;

private _sensorPos = _veh getVariable ["FLS_sensorPos", [0, 0, 0]];
if (_sensorPos isEqualTo [0, 0, 0]) then {
    _sensorPos = [_veh] call FLS_fnc_findSensorPos;
    _veh setVariable ["FLS_sensorPos", +_sensorPos];
};

private _nPingsThisUpdate = 0;
while {FLS_pingTimer > 0} do {

    private _scanDir = _scanDirStart + FLS_nextScanlineID*_dirStep;

    private _scanData = [ 
                            vehicle player,
                            _scanDir, // Direction offset - 0 - we scan directly ahead 
                            FLS_range, // Distance
                            _sensorPos,
                            selectRandom FLS_positionsEndLocal_sector
    ] call FLS_fnc_scan;

    private _scanlinePlotData = _scanData apply {
        _x params ["_angle", "_distance", "_cos"];

        //private _alpha = _cos; //(linearConversion [0, 1, _cos, -0.9, 6, false]) min 1;
        private _color = _cos call FLS_sectorColorFn; //[43/255, 210/255, 0, _alpha];
        [_scanDir, _distance, _color];
    };
    [_graph, FLS_nextScanlineID, _scanlinePlotData] call FLS_fnc_ui_graphPolarSetScanline;

    _nPingsThisUpdate = _nPingsThisUpdate+1;
    FLS_pingTimer = FLS_pingTimer - _pingInterval;
    FLS_nextScanlineID = (FLS_nextScanlineID + 1) mod _nScanlines;
};

if (_nPingsThisUpdate != 0) then {
    [_graph, 1.0] call FLS_fnc_ui_graphPolarRefresh;
};