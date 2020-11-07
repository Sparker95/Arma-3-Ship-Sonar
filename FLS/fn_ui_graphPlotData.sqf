#include "common.hpp"

// Plots data on the graph

params ["_ctrlGroup", "_values"];

#ifdef FLS_DEBUG
diag_log format ["FLS: plot data: %1", _values];
#endif

private _pointWidth = 0.01;
private _pointHeight = _pointWidth * safeZoneW / safeZoneH;

// Delete previous values if they exist
private _dataControls = _ctrlGroup getVariable "plotDataControls";
{
    ctrlDelete _x;
} forEach _dataControls;

_dataControls resize 0;

// Plot new data
{
    _x params ["_xPosGraph", "_yPosGraph", "_color"];
    private _posUI = [_ctrlGroup, _xPosGraph, _yPosGraph] call FLS_fnc_ui_graphToUI;
    private _ctrlPoint = (_ctrlGroup getVariable "parentDisplay") ctrlCreate ["RscText", -1, _ctrlGroup];
    _ctrlPoint ctrlSetPosition [(_posUI#0) - _pointWidth/2, (_posUI#1) - _pointHeight/2, _pointWidth, _pointHeight];
    _ctrlPoint ctrlSetBackgroundColor _color;
    _ctrlPoint ctrlCommit 0;
    _dataControls pushBack _ctrlPoint;
} forEach _values;

_ctrlGroup setVariable ["plotDataControls", _dataControls];
_ctrlGroup setVariable ["plotDataValues", +_values];