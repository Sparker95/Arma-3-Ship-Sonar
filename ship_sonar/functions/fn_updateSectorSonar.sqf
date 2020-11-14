private _pingInterval = 1/80;
private _scanDirStart = -90;
private _dirStep = 1;
private _nScanlines = 90*2 + 1;

private _graph = uiNamespace getVariable "FLS_graphPolarGroup";
private _panel = uiNamespace getVariable "FLS_panelGroup";
private _veh = vehicle player;

FLS_pingTimer = FLS_pingTimer + diag_deltaTime;

private _sensorPos = _veh getVariable ["FLS_sensorPos", [0, 0, 0]];
if (_sensorPos isEqualTo [0, 0, 0]) then {
    _sensorPos = [_veh] call FLS_fnc_findSensorPos;
    _veh setVariable ["FLS_sensorPos", +_sensorPos];
};

_sectorColorFn = {
    private _cos = _this;
    private _alpha = (_cos^FLS_gamma) max 0.04;
    [50/255, 240/255, 20/255, _alpha];
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

        private _color = _cos call _sectorColorFn;
        [_scanDir, _distance, _color];
    };
    [_graph, FLS_nextScanlineID, _scanlinePlotData] call FLS_fnc_ui_graphPolarSetScanline;

    _nPingsThisUpdate = _nPingsThisUpdate+1;
    FLS_pingTimer = FLS_pingTimer - _pingInterval;
    FLS_nextScanlineID = (FLS_nextScanlineID + 1) mod _nScanlines;
};

// Update graph range
[_graph, FLS_range] call FLS_fnc_ui_graphPolarSetLimit;

// Refresh graph
if (_nPingsThisUpdate != 0) then {
    [_graph, 1.0] call FLS_fnc_ui_graphPolarRefresh;
};

// Update indicators
FLS_indicatorUpdateTimer = FLS_indicatorUpdateTimer + diag_deltaTime;
if (FLS_indicatorUpdateTimer > 0.1) then {
    // Update indicators at the bottom of the screen
    /*
    _panel setVariable ["ctrlSpeed", _textSpeed];
    _panel setVariable ["ctrlDepth", _textDepth];
    _panel setVariable ["ctrlHeading", _textHeading];
    */
    private _ctrlSpeed = _panel getVariable "ctrlSpeed";
    private _ctrlRange = _panel getVariable "ctrlRange";
    private _ctrlHeading = _panel getVariable "ctrlHeading";

    // Speed
    private _speed_kmh = speed _veh;
    private _speed_knots = abs (_speed_kmh * 0.539957);
    private _textSpeed = "SPD ";
    _textSpeed = _textSpeed + (_speed_knots toFixed 1);
    _ctrlSpeed ctrlSetText _textSpeed;

    // Heading
    private _dir = round direction vehicle player;
    private _textHeading = format ["HDG %1", _dir];
    _ctrlHeading ctrlSetText _textHeading;

    // Range
    private _range = FLS_range;
    private _textRange = format ["RNG %1 M", _range];
    _ctrlRange ctrlSetText _textRange;

    FLS_indicatorUpdateTimer = FLS_indicatorUpdateTimer - 0.1;
};