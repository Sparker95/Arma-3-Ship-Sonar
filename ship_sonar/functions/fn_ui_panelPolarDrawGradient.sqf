private _panel = uiNamespace getVariable ["FLS_panelGroup", controlNull];
private _display = uinamespace getvariable ["FLS_layerDisplay", controlNull];

if (isNull _panel || isNull _display) exitWith {};

// Delete old gradient
private _oldGradient = _panel getVariable ["gradientGroup", ctrlNull];
if (!isNull _oldGradient) then {
    ctrlDelete _oldGradient;
};

// Create gradient
private _ctrlGradientGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _panel];
_panel setVariable ["gradientGroup", _ctrlGradientGroup];
private _gradientWidth = 0.05;
private _gradientHeight = 0.3;
_ctrlGradientGroup ctrlSetPosition [0.78, 0.183, _gradientWidth, _gradientHeight];
_ctrlGradientGroup ctrlCommit 0;

private _nLines = 16;
private _lineid = 0;
private _lineHeight = _gradientHeight/_nLines;
private _colorLut = FLS_colorLut;
private _lutSize = count _colorLut;
while {_lineid < _nLines} do {
    private _linePosY = (_nLines-_lineid-1)*_lineHeight;
    private _posLogical = _lineid/(_nLines-1);
    private _lineControl = _display ctrlCreate ["RscText", -1, _ctrlGradientGroup];
    _lineControl ctrlSetPosition [0, _linePosY, _gradientWidth, _lineHeight+0.003];
    private _colorid = floor (_posLogical*(_lutSize-1));
    private _color = _colorLut select _colorid;
    _lineControl ctrlSetBackgroundColor _color;
    _lineControl ctrlCommit 0;
    _lineid = _lineid + 1;
};