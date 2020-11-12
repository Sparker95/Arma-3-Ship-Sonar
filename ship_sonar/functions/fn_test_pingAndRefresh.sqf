#include "common.hpp"

// Sends ping and refreshes the display

private _sensorOffset = [vehicle player] call FLS_fnc_findSensorPos; 

#ifdef FLS_DEBUG
diag_log "FLS: PING";
#endif

private _scanData = [ 
                        vehicle player, 
                        _sensorOffset, 
                        0,  // Angle start
                        90, // Angle end
                        1,  // Resolution, degrees
                        100 // Distance, meters
] call FLS_fnc_scan;

#ifdef FLS_DEBUG
diag_log format ["FLS: scan data: %1", _scanData];
#endif

private _graphCtrl = uiNamespace getVariable "FLS_graphGroup";

// Convert scan data into proper coordinates
private _plotData = _scanData apply {
    _x params ["_angle", "_distance", "_cos", "_posIntersect"];
    private _distanceProjected = _distance * (cos _angle);
    private _depth = _distance * (sin _angle);
    // [minFrom, maxFrom, value, minTo, maxTo, clip]
    //private _brightness = (linearConversion [0, 1, _cos, 0.8, 1.0, false]) min 1;
    private _alpha = linearConversion [0, 1, _cos, -0.1, 6, false];
    private _color = [1, 206*(1-3*_cos)/255, 9*(1-3*_cos)/255, _alpha];
    [_distanceProjected, _depth, _color]
};

[_graphCtrl, _plotData] call FLS_fnc_ui_graphPlotData;