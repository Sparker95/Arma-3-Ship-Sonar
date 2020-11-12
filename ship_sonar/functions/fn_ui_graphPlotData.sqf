#include "common.hpp"

// Plots data on the graph

params ["_ctrlGroup", "_values"];

#ifdef FLS_DEBUG
diag_log format ["FLS: plot data: %1", _values];
#endif

private _pointWidth = 0.015;
private _pointHeight = _pointWidth * safeZoneW / safeZoneH;

// Delete previous values if they exist
private _dataControls = _ctrlGroup getVariable "plotDataControls";
// Disable all points, later those which are used will be reenabled
{
    _x ctrlShow false;
} forEach _dataControls;

// This returns a new control point,
// this is a cache of controls for points
private _nextPointID = 0;
private _getNewPoint = {
    private _return = controlNull; 
    if (_nextPointID >= (count _dataControls)) then {
        // There are no more points, add one more
        _ctrlPoint = (_ctrlGroup getVariable "parentDisplay") ctrlCreate ["RscPicture", -1, _ctrlGroup];
        _ctrlPoint ctrlSetText "ship_sonar\Dot.paa";
        _dataControls pushBack _ctrlPoint;
        _return = _ctrlPoint;
    } else {
        // Take next point from cache
        _return = _dataControls select _nextPointID;
    };
    _nextPointID = _nextPointID + 1;
    _return;
};

// Plot new data
{
    _x params ["_xPosGraph", "_yPosGraph", "_color", "_size"];
    private _posUI = [_ctrlGroup, _xPosGraph, _yPosGraph] call FLS_fnc_ui_graphToUI;
    private _ctrlPoint = call _getNewPoint;
    _ctrlPoint ctrlSetPosition [(_posUI#0) - _pointWidth/2, (_posUI#1) - _pointHeight/2, _pointWidth, _pointHeight];
    _ctrlPoint ctrlSetBackgroundColor _color;
    _ctrlPoint ctrlSetTextColor _color;
    _ctrlPoint ctrlShow true;
    _ctrlPoint ctrlCommit 0;
} forEach _values;

_ctrlGroup setVariable ["plotDataValues", +_values];