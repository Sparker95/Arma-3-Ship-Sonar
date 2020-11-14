#include "common.hpp"

// Initializes control with the graph plotter
// Sets its size and decorates it
// _ctrl - group control

params ["_display", ["_parentGroup", controlNull]];

// Delete old graph if it exists
if (!isNil {uiNamespace getVariable "FLS_graphPolarGroup"}) then {
    [uiNamespace getVariable "FLS_graphPolarGroup"] call FLS_fnc_ui_graphPolarDelete;
};

private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _parentGroup];
uiNamespace setVariable ["FLS_graphPolarGroup", _ctrlGroup];

// Size of this control
private _width = 0.8;
private _height = 0.6;
_ctrlGroup ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH - _height, _width, _height];

// Background
private _ctrlBackground = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ctrlBackground ctrlSetPosition [0, 0, _width, _height];
_ctrlBackground ctrlSetBackgroundColor [22/255, 67/255, 140/255, 1];
_ctrlBackground ctrlCommit 0;
_ctrlGroup setVariable ["ctrlBackground", _ctrlBackground];

// Size of plot area
private _plotWidth = 0.75;
private _plotHeight = _plotWidth * safeZoneW / safeZoneH;
_ctrlGroup setVariable ["plotWidth", _plotWidth];
_ctrlGroup setVariable ["plotHeight", _plotHeight];

// Polar grid picture
private _gridPicX = 0.02;
private _gridPicY = 0.02;
private _ctrlGridPic = _display ctrlCreate ["RscPicture", -1, _ctrlGroup];
_ctrlGridPic ctrlSetPosition [_gridPicX, _gridPicY, _plotWidth, _plotHeight];
//_ctrlGridPic ctrlSetBackgroundColor [1, 1, 1, 1];
_ctrlGridPic ctrlSetTextColor [1, 1, 1, 0.2];
_ctrlGridPic ctrlSetText "ship_sonar\GridPolar.paa";
_ctrlGridPic ctrlCommit 0;

// Origin of plot area
private _plotOriginX = _gridPicX + _plotWidth/2;
private _plotOriginY = _gridPicY + _plotHeight/2;
_ctrlGroup setVariable ["plotOriginX", _plotOriginX];
_ctrlGroup setVariable ["plotOriginY", _plotOriginY];

// Limits
_ctrlGroup setVariable ["distlim", 100]; // Max distance to plot

// Plot data
// We can't redraw whole plot at once,
// thus we will redraw at max a few scanlines
// Values are divided into scanlines
// Also we have an array which contains flags indicating which scanlines need to be redrawn
private _nScanlinesMax = 200; // Should be enough?
private _array = []; _array resize _nScanLinesMax;
_ctrlGroup setVariable ["plotScanlinesData", _array apply {[]}];
_ctrlGroup setVariable ["plotScanlinesPending", _array apply {false}];
_ctrlGroup setVariable ["plotScanlinesControls", _array apply {[]}];    // Controls of points

// Misc settings
_ctrlGroup ctrlSetBackgroundColor [0, 0, 0, 1];
_ctrlGroup setVariable ["parentDisplay", _display];

_ctrlGroup ctrlCommit 0;

_ctrlGroup