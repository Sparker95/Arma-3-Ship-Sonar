#include "common.hpp"

// Creates whole panel with UI

params ["_display"];

// Delete old panel if it exists
private _oldPanel = uiNamespace getVariable "FLS_panelGroup";
if (!isNil "_oldPanel") then {
    [_oldPanel] call FLS_fnc_ui_panelDelete;
};

private _panelWidth = 0.5;
private _panelHeight = 0.58;
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

[_display, _panel] call FLS_fnc_ui_graphCreate;


// Create labels for text
private _textDepth = _display ctrlCreate ["RscTextMulti", -1, _panel];
_textDepth ctrlSetText "DEP\n99.99";
_textDepth ctrlSetPosition [0, 0.45, 0.15, 0.12];

private _textSpeed = _display ctrlCreate ["RscTextMulti", -1, _panel];
_textSpeed ctrlSetText "SPD\n12.3";
_textSpeed ctrlSetPosition [0.2, 0.45, 0.15, 0.12];

private _textHeading = _display ctrlCreate ["RscTextMulti", -1, _panel];
_textHeading ctrlSetText "HDG\n275";
_textHeading ctrlSetPosition [0.2*2, 0.45, 0.15, 0.12];

// Just a line with units, so that unit text stays at a fixed place,
// Because we don't use a monospace font
private _textUnits = _display ctrlCreate ["RscTextMulti", -1, _panel];
_textUnits ctrlSetText "\n        M                kt";
_textUnits ctrlSetPosition [0, 0.45, 0.5, 0.12];

{
    _x ctrlSetFont "PuristaBold";
    _x ctrlSetTextColor [0.9, 0.9, 0.9, 1];
    //_x ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
    _x ctrlSetFontHeight 0.06;
    _x ctrlCommit 0;
} forEach [_textDepth, _textSpeed, _textHeading, _textUnits];

_panel setVariable ["ctrlSpeed", _textSpeed];
_panel setVariable ["ctrlDepth", _textDepth];
_panel setVariable ["ctrlHeading", _textHeading];

_panel ctrlCommit 0;

_panel;