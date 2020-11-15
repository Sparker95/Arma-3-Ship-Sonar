#include "common.hpp"

// Called only when device is active

private _panel = uiNamespace getVariable "FLS_panelGroup";
private _graph = uinamespace getvariable "FLS_graphGroup";
private _veh = vehicle player;

// Update our time counter
FLS_pingTimer = FLS_pingTimer + diag_deltaTime;

// Set this to true if we have performed a scan during this update
private _pinged = false;

if (FLS_pingTimer > FLS_pingInterval) then {
    // We must send a ping and update the graph

    #ifdef FLS_DEBUG
    diag_log "FLS: PING";
    #endif

    private _sensorPos = _veh getVariable ["FLS_sensorPos", [0, 0, 0]];
    if (_sensorPos isEqualTo [0, 0, 0]) then {
        _sensorPos = [_veh] call FLS_fnc_findSensorPos;
        _veh setVariable ["FLS_sensorPos", +_sensorPos];
    };

    private _scanData = [ 
                            vehicle player,
                            0, // Direction offset - 0 - we scan directly ahead 
                            FLS_range, // Distance
                            _sensorPos,
                            selectRandom FLS_positionsEndLocal_basicFLS
    ] call FLS_fnc_scan;

    #ifdef FLS_DEBUG
    diag_log format ["FLS: scan data: %1", _scanData];
    #endif

    private _graphCtrl = uiNamespace getVariable "FLS_graphGroup";

    // Convert scan data into graph coordinates:
    // X is projected distance of the point
    // Y is calculated depth of the point
    private _plotData = _scanData apply {
        _x params ["_angle", "_distance", "_cos"];
        private _distanceProjected = _distance * (cos _angle);
        private _depth = _distance * (sin _angle);
        // [minFrom, maxFrom, value, minTo, maxTo, clip]
        //private _brightness = (linearConversion [0, 1, _cos, 0.8, 1.0, false]) min 1;
        private _alpha = (linearConversion [0, 1, _cos, -0.1, 6, false]) min 1;
        private _color = [1, 206*(1-2*_cos)/255, 9*(1-2*_cos)/255, _alpha];
        [_distanceProjected, _depth, _color]
    };

    // Set new values to plot, don't plot it right now
    [_graphCtrl, _plotData] call FLS_fnc_ui_graphSetDataValues;

    FLS_lastScanData = _plotData;

    // Recalculate depth
    if (count _scanData > 0) then {
        private _lastPoint = _scanData select (count _scanData - 1);
        private _depth = _lastPoint#1;
        FLS_lastDepth = _depth;
    } else {
        FLS_lastDepth = -1;
    };

    FLS_pingTimer = FLS_pingTimer - FLS_pingInterval;
    FLS_graphRefreshPlot = true;
    _pinged = true;
};


FLS_indicatorUpdateTimer = FLS_indicatorUpdateTimer + diag_deltaTime;
if (FLS_indicatorUpdateTimer > 0.1) then {
    // Update indicators at the bottom of the screen
    /*
    _panel setVariable ["ctrlSpeed", _textSpeed];
    _panel setVariable ["ctrlDepth", _textDepth];
    _panel setVariable ["ctrlHeading", _textHeading];
    */
    private _ctrlSpeed = _panel getVariable "ctrlSpeed";
    private _ctrlDepth = _panel getVariable "ctrlDepth";
    private _ctrlHeading = _panel getVariable "ctrlHeading";

    // Speed
    private _speed_kmh = speed _veh;
    private _speed_knots = abs (_speed_kmh * 0.539957);
    private _textSpeed = format ["SPD\n"];
    _textSpeed = _textSpeed + (_speed_knots toFixed 1);
    _ctrlSpeed ctrlSetText _textSpeed;

    // Depth
    private _textDepth = "DEP\n";
    private _depth = FLS_lastDepth;
    if (_depth != -1) then {
        _textDepth = _textDepth + (_depth toFixed 1);
    };
    _ctrlDepth ctrlSetText _textDepth;

    // Heading
    private _dir = round direction vehicle player;
    private _textHeading = format ["HDG\n%1", _dir];
    _ctrlHeading ctrlSetText _textHeading;

    FLS_indicatorUpdateTimer = FLS_indicatorUpdateTimer - 0.1;
};

// Update scale of the graph
// We don't want to change scale if we've sent ping during this update
// Because it has to replot the data several times
FLS_scaleUpdateTimer = FLS_scaleUpdateTimer + diag_deltaTime;
if (FLS_scaleUpdateTimer > 0.8 || FLS_forceRefreshGrid) then {
    private _scanData = FLS_lastScanData;

    // If there is no ping return, set max scale

    FLS_maxDepth = FLS_maxDepthUser;

    // Calculate depth if we are setting it automatically
    private _ystep = 10;
    if (FLS_maxDepthUser == -1) then {
        private _actualDepth = FLS_lastDepth;
        switch (true) do {
            case (_actualDepth > 30): {
                FLS_maxDepth = 100;
            };
            case (_actualDepth > 16): {
                FLS_maxDepth = 40;
            };
            case (_actualDepth > 8): {
                FLS_maxDepth = 20;
            };
            case (_actualDepth > 3.5): {
                FLS_maxDepth = 10;
            };
            default {
                FLS_maxDepth = 2;
            };
        };
    };

    // Grid step
    private _ystep = FLS_maxDepth/4;
    private _xstep = FLS_range/4;
    
    [_graph, _xstep, _ystep] call FLS_fnc_ui_graphSetGridStep;
    [_graph, FLS_range, FLS_maxDepth] call FLS_fnc_ui_graphSetLimits;

    FLS_graphRefreshGrid = true;
    FLS_scaleUpdateTimer = FLS_scaleUpdateTimer - 0.8;
};

// Refresh the graph, but if we didn't ping during this update
// Ping and graph plot are quite costly, so we want to make sure we don't do them at same update
if ( ((FLS_graphRefreshGrid || FLS_graphRefreshPlot) && !_pinged) || FLS_forceRefreshGrid) then {
    [_graph, FLS_graphRefreshGrid, FLS_graphRefreshPlot] call FLS_fnc_ui_graphRefresh;
    FLS_graphRefreshGrid = false;
    FLS_graphRefreshPlot = false;
    FLS_forceRefreshGrid = false;
};