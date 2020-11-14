#include "common.hpp"

// Initializes control with the graph plotter
// Sets its size and decorates it
// _ctrl - group control

params ["_display", ["_parentGroup", controlNull]];

// Delete old graph if it exists
private _oldGraph = uiNamespace getVariable ["FLS_graphGroup", controlNull];
if (!isNull _oldGraph) then {
    [uiNamespace getVariable "FLS_graphGroup"] call FLS_fnc_ui_graphDelete;
};

private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _parentGroup];
uiNamespace setVariable ["FLS_graphGroup", _ctrlGroup];

// Size of this control
private _width = 0.5;
private _height = 0.455;
_ctrlGroup ctrlSetPosition [0, 0, _width, _height];

// Background
private _ctrlBackground = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ctrlBackground ctrlSetPosition [0, 0, _width, _height];
//_ctrlBackground ctrlSetBackgroundColor [22/255, 67/255, 140/255, 0.9];
_ctrlBackground ctrlCommit 0;
_ctrlGroup setVariable ["ctrlBackground", _ctrlBackground];

// Size of plot area
private _plotWidth = 0.4;
private _plotHeight = 0.4;
private _plotOriginX = 0.02;
private _plotOriginY = 0.05;

_ctrlGroup setVariable ["plotWidth", _plotWidth];
_ctrlGroup setVariable ["plotHeight", _plotHeight];
_ctrlGroup setVariable ["plotOriginX", _plotOriginX];
_ctrlGroup setVariable ["plotOriginY", _plotOriginY];

// Limits
_ctrlGroup setVariable ["xlim", 100];
_ctrlGroup setVariable ["ylim", 100];

// Plot data
_ctrlGroup setVariable ["plotDataValues", []];            // Raw plot values, must keep it so we can refresh the display if needed
_ctrlGroup setVariable ["plotDataControls", []];    // Controls of points

// Misc settings
_ctrlGroup ctrlSetBackgroundColor [0, 0, 0, 1];
_ctrlGroup setVariable ["parentDisplay", _display];

// Axis
_ctrlGroup setVariable ["ax_horizontal", []];
_ctrlGroup setVariable ["ax_vertical", []];
_ctrlGroup setVariable ["ax_xstep", 10];
_ctrlGroup setVariable ["ax_ystep", 10];

// Lables
private _xlable = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_xlable ctrlSetPosition [_plotOriginX + _plotWidth - 0.04, _plotOriginY - 0.05, 0.08, 0.05];
_xlable ctrlSetText "100M";

private _xlablemid = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_xlablemid ctrlSetPosition [_plotOriginX + 0.5*_plotWidth - 0.04, _plotOriginY - 0.05, 0.08, 0.05];
_xlablemid ctrlSetText "100M";

private _ylable = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ylable ctrlSetPosition [_plotOriginX + _plotWidth, _plotOriginY + _plotHeight - 0.04, 0.08, 0.05];
_ylable ctrlSetText "100M";

private _ylablemid = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ylablemid ctrlSetPosition [_plotOriginX + _plotWidth, _plotOriginY + 0.5*_plotHeight - 0.04, 0.08, 0.05];
_ylablemid ctrlSetText "100M";
{
    _x ctrlSetTextColor [0.9, 0.9, 0.9, 1];
    _x ctrlSetFontHeight 0.04;
    //_x ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
    _x ctrlSetFont "PuristaBold";
    _x ctrlCommit 0;
} forEach [_xlable, _xlablemid, _ylable, _ylablemid];

_ctrlGroup setVariable ["xlable", _xlable];
_ctrlGroup setVariable ["xlablemid", _xlablemid];
_ctrlGroup setVariable ["ylable", _ylable];
_ctrlGroup setVariable ["ylablemid", _ylablemid];


// Ship picture
private _ctrlShipPic = _display ctrlCreate ["RscPicture", -1, _ctrlGroup];
_ctrlShipPic ctrlSetPosition [0.01, -0.04, 0.08, 0.08];
//_ctrlShipPic ctrlSetBackgroundColor [1, 1, 1, 1];
_ctrlShipPic ctrlSetTextColor [0.9, 0.9, 0.9, 1];
_ctrlShipPic ctrlSetText "ship_sonar\IconShip.paa";
_ctrlShipPic ctrlCommit 0;


_ctrlGroup ctrlCommit 0;


// Plot axes, lables
[_ctrlGroup, 10, 10] call FLS_fnc_ui_graphPlotAxes;
[_ctrlGroup] call FLS_fnc_ui_graphUpdateLables;

_ctrlGroup