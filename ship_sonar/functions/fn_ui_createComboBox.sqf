#include "common.hpp"

// Creates a 'multibutton' control:
// A text field with several buttons on the right of it

params ["_display", "_parentGroup", "_text", "_lbText", "_xpos", "_ypos", "_width", "_comboWidth"];

diag_log format ["CreateComboBox: %1", _this];

private _group = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _parentGroup];
private _height = 0.05;
_group ctrlSetPosition [_xpos, _ypos, _width, _height];

private _ctrlText = _display ctrlCreate ["RscText", -1, _group];
_ctrlText ctrlSetBackgroundColor [0,0,0,0]; //[0, 1, 0, 0.3];
_ctrlText ctrlSetTextColor [0.9, 0.9, 0.9, 1];
_ctrlText ctrlSetText _text;
_ctrlText ctrlSetFont "PuristaBold";
_ctrlText ctrlSetPosition [0, 0, ctrlTextWidth _ctrlText, _height];
_ctrlText ctrlCommit 0;

private _combobox = _display ctrlCreate ["RscCombo", -1, _group];
_combobox ctrlSetPosition [_width - _comboWidth, 0, _comboWidth, _height];
{
    _combobox lbAdd _x;
} forEach _lbText;
_combobox ctrlSetFont "PuristaBold";
_combobox ctrlCommit 0;

_group setVariable ["comboBox", _combobox];

_group ctrlCommit 0;
_group;