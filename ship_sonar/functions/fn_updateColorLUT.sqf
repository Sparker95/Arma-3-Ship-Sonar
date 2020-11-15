params ["_newMode"];

// Recalculates the color look-up table according to current sonar mode

// Look-up table size

if (_newMode == "sectorImage") exitWith {
    // We use a basic scheme, color is fixed, alpha depends on value
    // Value is gamma-corrected
    FLS_colorLut = []; FLS_colorLut resize FLS_colorLutSize;
    private _i = 0;
    while {_i < FLS_colorLutSize} do {
        private _value = _i/(FLS_colorLutSize-1);
        private _alpha = (_value^FLS_gamma) max 0.04;
        private _color = [50/255, 240/255, 20/255, _alpha];
        FLS_colorLut set [_i, _color];
        _i = _i + 1;
    };
};

// For sector depth graph we use a color gradient  
if (_newMode == "sectorDepth") exitWith {
    
    #define RGBA(r, g, b, a) [r/255, g/255, b/255, a]

    // blue -> green -> orange -> red
    private _a = 0.9;
    private _colorScheme = [
        [0, RGBA(23, 135, 195, _a)],
        [0.3, RGBA(0, 182, 85, _a)],
        [0.75, RGBA(255, 206, 0, _a)],
        [1, RGBA(255, 0, 0, _a)]
    ];

    // Function for calculating color gradients
    // Input value must be within 0..1 range
    private _calculateGradient = {
        params ["_value", "_ranges"];
        
        _value = (_value min 1) max 0;

        private _range0 = (count _ranges) - 1;
        while {_range0 > 0} do {
            private _rangeStart = _ranges#_range0#0;
            if (_rangeStart <= _value) exitWith {};
            _range0 = _range0 - 1;
        };
        private _range1 = _range0 + 1;

        private _color0 = _ranges#_range0#1;
        private _color1 = _ranges#_range1#1;
        private _value0 = _ranges#_range0#0;
        private _value1 = _ranges#_range1#0;
        
        private _color = [];
        private _chan = 0;
        while {_chan < count _color0} do {
            private _chanValue = linearConversion [_value0, _value1, _value, _color0#_chan, _color1#_chan, true];
            _color pushBack _chanValue;
            _chan = _chan + 1;
        };
        _color;
    };

    // Calculate color look-up table
    private _colorLUTSize = FLS_colorLutSize;
    FLS_colorLut = [];
    FLS_colorLut resize _colorLUTSize;
    private _i = 0;
    while {_i < _colorLUTSize} do {
        private _inputValue = _i/_colorLUTSize; // 0..1
        private _color = [_inputValue, _colorScheme] call _calculateGradient;
        FLS_colorLut set [_i, _color];
        _i = _i + 1;
    };
};