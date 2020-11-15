#include "common.hpp"

// Creates whole polar panel with UI

params ["_display"];

// Delete old panel if it exists
private _oldPanel = uiNamespace getVariable ["FLS_panelGroup", controlNull];
if (!isNull _oldPanel) then {
    [_oldPanel] call FLS_fnc_ui_panelDelete;
};

private _panelWidth = 0.85;
private _panelHeight = 0.55;
private _offsetX = 0.03;
private _offsetY = _offsetX * safeZoneW / safeZoneH;

private _panel = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
uiNamespace setVariable ["FLS_panelGroup", _panel];

_panel ctrlSetPosition [ safeZoneX + _offsetX, safeZoneY + safeZoneH - _panelHeight - _offsetY, _panelWidth, _panelHeight];

// Background
private _ctrlBackground = _display ctrlCreate ["RscText", -1, _panel];
_ctrlBackground ctrlSetPosition [0, 0, _panelwidth, _panelheight];
_ctrlBackground ctrlSetBackgroundColor [22/255, 67/255, 140/255, 0.95];
_ctrlBackground ctrlCommit 0;
_panel setVariable ["ctrlBackground", _ctrlBackground];

// Graph
private _graph = [_display, _panel] call FLS_fnc_ui_graphPolarCreate;
_panel setVariable ["FLS_graph", _graph];

// Text for other indicators
private _textRange = _display ctrlCreate ["RscText", -1, _panel];
_textRange ctrlSetText "RNG 400 M";
_textRange ctrlSetPosition [0, -0.03, 0.2, 0.12];

private _textSpeed = _display ctrlCreate ["RscText", -1, _panel];
_textSpeed ctrlSetText "SPD 12.3";
_textSpeed ctrlSetPosition [0.62, -0.03, 0.2, 0.12];

private _textUnitsSpeed = _display ctrlCreate ["RscText", -1, _panel];
_textUnitsSpeed ctrlSetText "               kt";
_textUnitsSpeed ctrlSetPosition [0.62, -0.03, 0.2, 0.12];

private _textHeading = _display ctrlCreate ["RscText", -1, _panel];
_textHeading ctrlSetText "HDG 275";
_textHeading ctrlSetPosition [0.62, 0.03, 0.2, 0.12];

{
    _x ctrlSetFont "PuristaBold";
    _x ctrlSetTextColor [0.9, 0.9, 0.9, 1];
    //_x ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
    _x ctrlSetFontHeight 0.06;
    _x ctrlCommit 0;
} forEach [_textRange, _textSpeed, _textHeading, _textUnitsSpeed];

_panel setVariable ["ctrlSpeed", _textSpeed];
_panel setVariable ["ctrlRange", _textRange];
_panel setVariable ["ctrlHeading", _textHeading];

private _textScaleMax = _display ctrlCreate ["RscText", -1, _panel];
_textScaleMax ctrlSetPosition [0.774, 0.1, 0.2, 0.12];
_textScaleMax ctrlSetFont "PuristaBold";
_textScaleMax ctrlSetFontHeight 0.04;
_panel setVariable ["ctrlScaleMax", _textScaleMax];

private _textScaleMin = _display ctrlCreate ["RscText", -1, _panel];
_textScaleMin ctrlSetPosition [0.774, 0.445, 0.2, 0.12];
_textScaleMin ctrlSetFont "PuristaBold";
_textScaleMin ctrlSetFontHeight 0.04;
_panel setVariable ["ctrlScaleMin", _textScaleMin];

_textScaleMin ctrlSetText "MIN";
_textScaleMax ctrlSetText "MAX";

{
    _x ctrlSetTextColor [0.9, 0.9, 0.9, 1];
    _x ctrlCommit 0;
} forEach [_textScaleMin, _textScaleMax];

// Draw gradient
call FLS_fnc_ui_panelPolarDrawGradient;

_panel ctrlCommit 0;