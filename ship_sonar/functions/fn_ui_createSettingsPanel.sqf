#include "common.hpp"

// Delete old panel
private _oldDisplay = uins getv ["FLS_settingsDisplay", displayNull];
if (!isNull _oldDisplay) then {
    _oldDisplay closeDisplay 0;
};

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
uiNamespace setVariable ["FLS_settingsDisplay", _display];

private _textColor = [0.9, 0.9, 0.9, 1];

private _width = 0.65;
private _height = 0.31;
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
private _row2 = 0;
private _yoffset = 0.07;
private _rowWidth = 0.3;
private _xpos = 0.01;
private _xpos2 = _xpos + _rowWidth + 0.02;
private _comboWidth = 0.2;
private _ystep = 0.06;

// POWER
private _groupPower = [_display, _ctrlGroup, "POWER", ["OFF", "ON"], _xpos, _yoffset + _row*_ystep, _rowWidth, 0.12] call FLS_fnc_ui_createComboBox;
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
private _groupRange = [_display, _ctrlGroup, "RANGE", _rangeTexts, _xpos, _yoffset + _row*_ystep, _rowWidth, 0.12] call FLS_fnc_ui_createComboBox;
private _comboRange = _groupRange getv "combobox";
_ctrlGroup setv ["comboRange", _comboRange];
_row = _row + 1;

// MAX DEPTH
private _depthTexts = FLS_maxDepthOptions apply { if (_x == -1) then {"AUTO"} else {str _x}; };
private _groupMaxDepth = [_display, _ctrlGroup, "MAX DEPTH", _depthTexts, _xpos, _yoffset + _row*_ystep, _rowWidth, 0.12] call FLS_fnc_ui_createComboBox;
private _comboMaxDepth = _groupMaxDepth getv "combobox";
_ctrlGroup setv ["comboMaxDepth", _comboMaxDepth];
_row = _row + 1;

// GAMMA
private _gammaTexts = FLS_gammaOptions apply {str _x};
private _groupGamma = [_display, _ctrlGroup, "IMAGE GAMMA", _gammaTexts, _xpos2, _yoffset + _row2*_ystep, _rowWidth, 0.12] call FLS_fnc_ui_createComboBox;
private _comboGamma = _groupGamma getv "combobox";
_ctrlGroup setv ["comboGamma", _comboGamma];
_row2 = _row2 + 1;

// SCAN SPEED
private _scanSpeedTexts = FLS_scanSpeedOptions apply {format ["%1%2", _x, "%"]};
private _groupScanSpeed = [_display, _ctrlGroup, "SCAN RATE", _scanSpeedTexts, _xpos2, _yoffset + _row2*_ystep, _rowWidth, 0.12] call FLS_fnc_ui_createComboBox;
private _comboScanSpeed = _groupScanSpeed getv "combobox";
_ctrlGroup setv ["comboScanSpeed", _comboScanSpeed];
_row2 = _row2 + 1;

// Fake button we use to reset focus
private _fakeButton = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_fakeButton ctrlSetPosition [-1, -1, 0.3, 0.3];
_fakeButton ctrlCommit 0;
_ctrlGroup setv ["fakeButton", _fakeButton];

// Select combo box settings
_comboRange lbSetCurSel (FLS_rangeOptions find FLS_range);
_comboPower lbSetCurSel ([0, 1] select FLS_active);
_comboMode lbSetCurSel (FLS_modes find FLS_mode);
_comboGamma lbSetCurSel (FLS_gammaOptions find FLS_gamma);
_comboMaxDepth lbSetCurSel (FLS_maxDepthOptions find FLS_maxDepthUser);
_comboScanSpeed lbSetCurSel (FLS_scanSpeedOptions find FLS_scanSpeed);


// Add event handlers to combo boxes
_comboPower ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _active = [false, true] select _selectedIndex;
    if (!isNil "_active") then {
        [_active] call FLS_fnc_setPower;
    };
    call FLS_fnc_resetFocus;
}];

_comboRange ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _range = FLS_rangeOptions select _selectedIndex;
    if (!isNil "_range") then {
        [_range] call FLS_fnc_setRange;
    };
    call FLS_fnc_resetFocus;
}];

_comboMode ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _mode = FLS_modes select _selectedIndex;
    [_mode] call FLS_fnc_setMode;
    call FLS_fnc_resetFocus;
}];

_comboGamma ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _gamma = FLS_gammaOptions select _selectedIndex;
    if (!isNil "_gamma") then {
        FLS_gamma = _gamma;
        [FLS_mode] call FLS_fnc_updateColorLUT;
        if (FLS_active) then {
            call FLS_fnc_ui_panelPolarDrawGradient;
        };
    };
    call FLS_fnc_resetFocus;
}];

_comboMaxDepth ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _maxDepth = FLS_maxDepthOptions select _selectedIndex;
    if (!isNil "_maxDepth") then {
        FLS_maxDepthUser = _maxDepth;
    };
    call FLS_fnc_resetFocus;
}];

_comboScanSpeed ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    private _scanSpeed = FLS_scanSpeedOptions select _selectedIndex;
    if (!isNil "_scanSpeed") then {
         FLS_scanSpeed = _scanSpeed;
    };
    call FLS_fnc_resetFocus;
}];

// Function to reset settings focus
// It's too annoying when you have settings open and controling your ship
// It keeps chaning settings
FLS_fnc_resetFocus = {
    private _panel = uinamespace getvariable ["FLS_settingsPanel", controlNull];
    private _fake = _panel getVariable ["fakeButton", controlNull];
    ctrlSetFocus _fake;
};