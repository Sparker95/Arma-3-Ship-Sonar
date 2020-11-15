private _pingInterval = 1/60;

private _vectorsEndLocal = 0;
private _scanDirStart = 0;
private _dirStep = 0;
private _nScanlines = 0;

if (FLS_mode == "sectorImage") then {
    _scanDirStart = -90;
    _dirStep = 1; // !!!! Make sure it always passed direction = 0! We calculate depth from the forward scan!
    _nScanlines = 90*2 + 1;
    _vectorsEndLocal = FLS_positionsEndLocal_sector;
} else {
    _scanDirStart = -90;
    _dirStep = 2.5; // !!!! Make sure it always passed direction = 0! We calculate depth from the forward scan!
    _nScanlines = 90/2.5*2 + 1;
    _vectorsEndLocal = FLS_positionsEndLocal_sectorDepth;
};

private _graph = uiNamespace getVariable "FLS_graphPolarGroup";
private _panel = uiNamespace getVariable "FLS_panelGroup";
private _veh = vehicle player;

FLS_pingTimer = FLS_pingTimer + diag_deltaTime;

private _sensorPos = _veh getVariable ["FLS_sensorPos", [0, 0, 0]];
if (_sensorPos isEqualTo [0, 0, 0]) then {
    _sensorPos = [_veh] call FLS_fnc_findSensorPos;
    _veh setVariable ["FLS_sensorPos", +_sensorPos];
};

private _nPingsThisUpdate = 0;
while {FLS_pingTimer > 0} do {

// If we are done with this horizontal scan, update the max depth now
    // We want to synchronize this with scan so it doesn't happen in the middle of sweep
    if (FLS_nextScanlineID == 0) then {

        if (FLS_mode == "sectorDepth") then {
            FLS_maxDepth = FLS_maxDepthUser;
            // Override if we are setting range automatically
            if (FLS_maxDepthUser == -1) then {
                private _actualDepth = FLS_lastDepth;
                private _t = 0.9; // treshold for switching ot next range
                switch (true) do {
                    case (_actualDepth > _t*40): {
                        FLS_maxDepth = 100;
                    };
                    case (_actualDepth > _t*20): {
                        FLS_maxDepth = 40;
                    };
                    case (_actualDepth > _t*10): {
                        FLS_maxDepth = 20;
                    };
                    case (_actualDepth > _t*4): {
                        FLS_maxDepth = 10;
                    };
                    case (_actualDepth > _t*2): {
                        FLS_maxDepth = 4;
                    };
                    default {
                        FLS_maxDepth = 2;
                    };
                };
            };

            private _ctrlTextMin = _panel getVariable "ctrlScaleMin";
            private _ctrlTextMax = _panel getVariable "ctrlScaleMax";
            _ctrlTextMax ctrlSetText "0 M";
            _ctrlTextMin ctrlSetText (format ["%1 M", FLS_maxDepth]);
        };
    };

    private _scanDir = _scanDirStart + FLS_nextScanlineID*_dirStep;

    private _scanData = [ 
                            vehicle player,
                            _scanDir, // Direction offset - 0 - we scan directly ahead 
                            FLS_range, // Distance
                            _sensorPos,
                            selectRandom _vectorsEndLocal
    ] call FLS_fnc_scan;

    _scanlinePlotData = 0;

    private _lutSizem1 = FLS_colorLutSize-1;
    if (FLS_mode == "sectorImage") then {
        // Sector image mode
        _scanlinePlotData = _scanData apply {
            _x params ["_angle", "_distance", "_cos"];

            private _cosNormalized = (_cos min 1) max 0;
            private _color = +(FLS_colorLut select (_cosNormalized*_lutSizem1));
            [_scanDir, _distance, _color];
        };
    } else {
        // Sector depth mode
        private _maxDepth = FLS_maxDepth;
        _scanlinePlotData = _scanData apply {
            _x params ["_angle", "_distance", "_cos"];

            private _distanceProjected = _distance * (cos _angle);
            private _depth = _distance * (sin _angle);
            private _depthNormalized = ((1 - _depth/_maxDepth) min 1) max 0;
            private _color = +(FLS_colorLut select (_depthNormalized*_lutSizem1));
            [_scanDir, _distanceProjected, _color];
        };

        // Recalculate depth when we send a ping forward
        if (_scanDir == 0) then {
            // Recalculate depth
            if (count _scanData > 0) then {
                private _lastPoint = _scanData select (count _scanData - 1);
                private _depth = _lastPoint#1;
                FLS_lastDepth = _depth;
            } else {
                FLS_lastDepth = -1;
            };
        };
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
    [_graph, _dirStep] call FLS_fnc_ui_graphPolarRefresh;
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