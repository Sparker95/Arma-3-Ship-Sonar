#include "common.hpp"

private _sensorOffset = [vehicle player] call FLS_fnc_findSensorPos; 

#ifdef FLS_DEBUG
diag_log "FLS: 3D PING";
#endif

private _scanLines = [];
for "_dirOffset" from -70 to 70 do {
    private _scanLineData = [ 
                            vehicle player, 
                            _sensorOffset, 
                            0,  // Angle start
                            90, // Angle end
                            1,  // Resolution, degrees
                            100, // Distance, meters
                            _dirOffset
    ] call FLS_fnc_scan;
    _scanLines pushBack [_dirOffset, _scanLineData];
};


#ifdef FLS_DEBUG
diag_log format ["FLS: scan data: %1", _scanData];
#endif

private _graphCtrl = uiNamespace getVariable "FLS_graphGroup";

// Convert scan data into proper coordinates
private _plotData = [];

{
    _x params ["_dirOffset", "_scanLineData"];
    private _dirOffsetGraph = _dirOffset + 70;
    _plotData append (_scanLineData apply {
        _x params ["_angle", "_distance", "_cos", "_posIntersectWorld"];
        private _alpha = _cos; //(linearConversion [0, 1, _cos, -0.9, 6, false]) min 1;
        private _color = [43/255, 210/255, 0, _alpha];
        private _xPosGraph = _distance * (cos _dirOffsetGraph);
        private _yPosGraph = _distance * (sin _dirOffsetGraph);
        _size = (0.7*_distance / 100) max 0.2;
        [_xPosGraph, _yPosGraph, _color, _size];
    });
} forEach _scanLines;

[_graphCtrl, _plotData] call FLS_fnc_ui_graphSetDataValues;
[_graphCtrl, 10, 10] call FLS_fnc_ui_graphSetGridStep;
[_graphCtrl, 100, 100] call FLS_fnc_ui_graphSetLimits;
[_graphCtrl, true, true] call FLS_fnc_ui_graphRefresh;