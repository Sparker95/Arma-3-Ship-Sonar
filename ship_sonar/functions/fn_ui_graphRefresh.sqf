// Replots the whole graph

params ["_ctrlGroup", "_refreshGrid", "_refreshPlot"];

if (_refreshGrid) then {
    // Refresh grids
    private _xstep = _ctrlGroup getVariable "ax_xstep";
    private _ystep = _ctrlGroup getVariable "ax_ystep";
    [_ctrlGroup, _xstep, _ystep] call FLS_fnc_ui_graphPlotAxes;

    // Refresh lables
    [_ctrlGroup] call FLS_fnc_ui_graphUpdateLables;
};

if (_refreshPlot) then {
    // Refresh data
    private _plotData = _ctrlGroup getVariable "plotDataValues";
    [_ctrlGroup, _plotData] call FLS_fnc_ui_graphPlotData;
};