// Called before mission start

// Initialize variables
FLS_active = false;
FLS_pingTimer = 0;
FLS_indicatorUpdateTimer = 0;
FLS_scaleUpdateTimer = 0;
FLS_lastScanData = [];
FLS_lastDepth = 0;
FLS_graphRefreshGrid = false;
FLS_graphRefreshPlot = false;

// Add per frame handler to update device
FLS_PFHID = addMissionEventHandler ["EachFrame", {
    call FLS_fnc_onEachFrame;
}];


// Prepare vectors

// Array with end positions of vectors for generating ray casts
// We pre-compute them for performance reasons, because we need them to be
// somewhat randomized
private _positionsEndLocalArray = [];
private _beamWidth = 4;
private _angleStart = 0;
private _angleEnd = 90;
private _angles = [];
private _angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _angleIncrement = (10*((sin _angle)^2) max 0.1);
    _angle = _angle + _angleIncrement;
    _angles pushBack _angle;
};
for "_i" from 0 to 200 do {
    private _positionsEndLocal = _angles apply 
    {
        private _angle = _x;
        private _angleRandomized = _angle + random [-_beamWidth/2, 0, _beamWidth/2];
        private _randomDir = random [-_beamWidth/2, 0, _beamWidth/2];
        private _vecFwdLocal = [sin (_randomDir), cos (_randomDir), 0];
        private _posEndLocal = (_vecFwdLocal vectorMultiply ((cos _angleRandomized)));
        _posEndLocal = _posEndLocal vectorAdd ([0, 0, 1] vectorMultiply (-(sin _angleRandomized)));
        [_angle, _posEndLocal];
    };
    _positionsEndLocalArray pushBack _positionsEndLocal;
};
FLS_positionsEndLocal_basicFLS = _positionsEndLocalArray;