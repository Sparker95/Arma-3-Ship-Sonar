#include "common.hpp"

/*
Sets limits of data
*/

params ["_ctrlGroup", "_xlim", "_ylim"];

#ifdef FLS_DEBUG
diag_log format ["FLS: set graph limits: %1", _this];
#endif

_ctrlGroup setVariable ["xlim", _xlim];
_ctrlGroup setVariable ["ylim", _ylim];

// Refresh grids
private _xstep = _ctrlGroup getVariable "ax_xstep";
private _ystep = _ctrlGroup getVariable "ax_ystep";
[_ctrlGroup, _xstep, _ystep] call FLS_fnc_ui_graphPlotAxes;

// Refresh data
private _plotData = _ctrlGroup getVariable "plotDataValues";
[_ctrlGroup, _plotData] call FLS_fnc_ui_graphPlotData;

// Refresh lables
[_ctrlGroup] call FLS_fnc_ui_graphUpdateLables;