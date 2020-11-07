#include "common.hpp"

// Draws horizontal and vertical axes

// _stepX, _stepY are in graph scale
params ["_ctrlGroup", "_stepX", "_stepY"];

#ifdef FLS_DEBUG
diag_log format ["FLS: plot axes: %1", _this];
#endif

private _lineWidth = 0.002;
private _lineHeight = _lineWidth * safeZoneW / safeZoneH;

// Delete previous axes
{
    ctrlDelete _x;
} forEach (_ctrlGroup getVariable "ax_horizontal");
{
    ctrlDelete _x;
} forEach (_ctrlGroup getVariable "ax_vertical");

private _ax_vertical = [];
private _ax_horizontal = [];

private _createLineControl = {
    params ["_ctrlGroup"];
    private _ctrl = (_ctrlGroup getVariable "parentDisplay") ctrlCreate ["RscText", -1, _ctrlGroup];
    _ctrl ctrlSetBackgroundColor [188/255, 201/255, 44/255, 0.5];
    _ctrl;
};

private _plotWidth = _ctrlGroup getVariable "plotWidth";
private _plotHeight = _ctrlGroup getVariable "plotHeight";
private _plotOriginX = _ctrlGroup getVariable "plotOriginX";
private _plotOriginY = _ctrlGroup getVariable "plotOriginY";
private _xlim = _ctrlGroup getVariable "xlim";
private _ylim = _ctrlGroup getVariable "ylim";

// Make vertical lines
private _xGraph = 0;
while {_xGraph < _xlim + 0.5} do { // Hack to make it also plot the final line
    private _pos0UI = [_ctrlGroup, _xGraph, 0] call FLS_fnc_ui_graphToUI;
    private _ctrlLine = [_ctrlGroup] call _createLineControl;
    _ctrlLine ctrlSetPosition [_pos0UI#0, _pos0UI#1, _lineWidth, _plotHeight];
    _ax_vertical pushBack _ctrlLine;
    _ctrlLine ctrlCommit 0;
    _xGraph = _xGraph + _stepX;
};

// Make horizontal lines
private _yGraph = 0;
while {_yGraph < _ylim + 0.5} do { // Hack to make it also plot the final line
    private _pos0UI = [_ctrlGroup, 0, _yGraph] call FLS_fnc_ui_graphToUI;
    private _ctrlLine = [_ctrlGroup] call _createLineControl;
    _ctrlLine ctrlSetPosition [_pos0UI#0, _pos0UI#1, _plotWidth, _lineHeight];
    _ax_horizontal pushBack _ctrlLine;
    _ctrlLine ctrlCommit 0;
    _yGraph = _yGraph + _stepY;
};

_ctrlGroup setVariable ["ax_vertical", _ax_vertical];
_ctrlGroup setVariable ["ax_horizontal", _ax_horizontal];