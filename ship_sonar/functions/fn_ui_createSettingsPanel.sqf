#include "common.hpp"

// Delete old panel
private _oldDisplay = uins getv ["FLS_settingsDisplay", displayNull];
if (!isNull _oldDisplay) then {
    _oldDisplay closeDisplay 0;
};

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
uiNamespace setVariable ["FLS_settingsDisplay", _display];

private _textColor = [0.9, 0.9, 0.9, 1];

private _width = 0.33;
private _height = 0.33;
private _offsetX = 0.03;
private _offsetY = _offsetX * safeZoneW / safeZoneH;
private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
uiNamespace setVariable ["FLS_settingsPanel", _ctrlGroup];
_ctrlGroup ctrlSetPosition [safeZoneX + _offsetX, safeZoneY + safeZoneH - 0.6 - _height - _offsetY, _width, _height + 0.4];
_ctrlGroup ctrlCommit 0;

// Background
private _ctrlBackground = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ctrlBackground ctrlSetPosition [0, 0, _width, _height];
_ctrlBackground ctrlSetBackgroundColor [22/255, 67/255, 140/255, 0.95];
_ctrlBackground ctrlCommit 0;
_ctrlGroup setVariable ["ctrlBackground", _ctrlBackground];

// Logo
private _ctrlLogo = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_ctrlLogo ctrlSetPosition [0.01, 0, _width, 0.06];
_ctrlLogo ctrlSetText "Sonar Settings";
_ctrlLogo ctrlSetFont "PuristaBold";
_ctrlLogo ctrlSetTextColor _textColor;
_ctrlLogo ctrlSetFontHeight 0.05;
_ctrlLogo ctrlCommit 0;

// Combo boxes
private _row = 0;
private _yoffset = 0.07;
private _xpos = 0.01;
private _rowWidth = 0.3;
private _comboWidth = 0.2;
private _ystep = 0.06;

// POWER
private _groupPower = [_display, _ctrlGroup, "POWER", ["OFF", "ON"], _xpos, _yoffset + _row*_ystep, _rowWidth, 0.1] call FLS_fnc_ui_createComboBox;
private _comboPower = _groupPower getv "combobox";
_ctrlGroup setv ["comboPower", _comboPower];
_row = _row + 1;

// MODE
private _modes = FLS_modeNames;
private _groupMode = [_display, _ctrlGroup, "MODE", _modes, _xpos, _yoffset + _row*_ystep, _rowWidth, 0.2] call FLS_fnc_ui_createComboBox;
private _comboMode = _groupMode getv "combobox";
_ctrlGroup setv ["comboMode", _comboMode];
_row = _row + 1;

// RANGE
private _rangeTexts = FLS_rangeOptions apply {str _x};
private _groupRange = [_display, _ctrlGroup, "RANGE", _rangeTexts, _xpos, _yoffset + _row*_ystep, _rowWidth, 0.1] call FLS_fnc_ui_createComboBox;
private _comboRange = _groupRange getv "combobox";
_ctrlGroup setv ["comboRange", _comboRange];
_row = _row + 1;

// GAMMA
private _gammaTexts = FLS_gammaOptions apply {str _x};
private _groupGamma = [_display, _ctrlGroup, "IMAGE GAMMA", _gammaTexts, _xpos, _yoffset + _row*_ystep, _rowWidth, 0.1] call FLS_fnc_ui_createComboBox;
private _comboGamma = _groupGamma getv "combobox";
_ctrlGroup setv ["comboGamma", _comboGamma];
_row = _row + 1;

// Select combo box settings
_comboRange lbSetCurSel (FLS_rangeOptions find FLS_range);
_comboPower lbSetCurSel ([0, 1] select FLS_active);
_comboMode lbSetCurSel (FLS_modes find FLS_mode);
_comboGamma lbSetCurSel (FLS_gammaOptions find FLS_gamma);


// Add event handlers to combo boxes
_comboPower ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _active = [false, true] select _selectedIndex;
    if (!isNil "_active") then {
        [_active] call FLS_fnc_setPower;
    };
}];

_comboRange ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _range = FLS_rangeOptions select _selectedIndex;
    if (!isNil "_range") then {
        [_range] call FLS_fnc_setRange;
    };
}];

_comboMode ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _mode = FLS_modes select _selectedIndex;
    [_mode] call FLS_fnc_setMode;
}];

_comboGamma ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _gamma = FLS_gammaOptions select _selectedIndex;
    if (!isNil "_gamma") then {
        FLS_gamma = _gamma;
    };
}];