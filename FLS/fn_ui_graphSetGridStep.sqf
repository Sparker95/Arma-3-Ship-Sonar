#include "common.hpp"

/*
Sets steps for the grid
*/

params ["_ctrlGroup", "_xstep", "_ystep"];

_ctrlGroup setVariable ["ax_xstep", _xstep];
_ctrlGroup setVariable ["ax_ystep", _ystep];

// Refresh grids
[_ctrlGroup, _xstep, _ystep] call FLS_fnc_ui_graphPlotAxes;

// Refresh data
private _plotData = _ctrlGroup getVariable "plotDataValues";
[_ctrlGroup, _plotData] call FLS_fnc_ui_graphPlotData;