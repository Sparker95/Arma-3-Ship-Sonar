params ["_ctrlGroup", "_dirStepDeg"];

private _dirStepRad = _dirStepDeg/180*pi;
private _scanlinesPending = _ctrlGroup getVariable "plotScanlinesPending";


// Some common stuff

// This returns a new control point,
private _getNewPoint = {
    private _return = controlNull; 
    if (_nextPointID >= (count _dataControls)) then {
        // There are no more points, add one more
        _ctrlPoint = (_ctrlGroup getVariable "parentDisplay") ctrlCreate ["RscPicture", -1, _ctrlGroup];
        _ctrlPoint ctrlSetText "\ship_sonar\Dot.paa";
        _dataControls pushBack _ctrlPoint;
        _return = _ctrlPoint;
    } else {
        // Take next point from cache
        _return = _dataControls select _nextPointID;
    };
    _nextPointID = _nextPointID + 1; // this variable comes from upper scope!
    _return;
};

private _originx = _ctrlGroup getVariable "plotOriginX";
private _originy = _ctrlGroup getVariable "plotOriginY";
private _width = _ctrlGroup getVariable "plotWidth";
private _height = _ctrlGroup getVariable "plotHeight";
private _distlim = _ctrlGroup getVariable "distlim";

#define POINT_SIZE_REL_TO_UI(size) [size*_width/2, size*_height/2]

private _scanlineID = 0;
private _nScanlines = count (_ctrlGroup getVariable "plotScanlinesData");
while {_scanlineID < _nScanlines} do { //  forEach _scanlinesPending;

    // If this scanline needs an update
    if (_scanlinesPending#_scanlineID) then {
        private _values = (_ctrlGroup getVariable "plotScanlinesData") select _scanlineID;

        // Delete previous values if they exist
        private _dataControls = (_ctrlGroup getVariable "plotScanlinesControls") select _scanlineID;
        // Disable all points, later those which are used will be reenabled
        {
            _x ctrlShow false;
        } forEach _dataControls;

        private _nextPointID = 0;

        {
            _x params ["_angle", "_distance", "_color"];
            if (_distance <= _distlim) then {
                private _distRel = _distance/_distLim*0.975; // Slight correction for grid scale, it's not perfect
                private _xpos = _originx + 0.5*_distRel*_width*(sin _angle);
                private _ypos = _originy - 0.5*_distRel*_height*(cos _angle);
                private _ctrlPoint = call _getNewPoint;
                // _distRel * _dirStepRad * 0.17;
                private _pointSizeRel = sqrt (_distRel*_dirStepRad*0.04);
                POINT_SIZE_REL_TO_UI(_pointSizeRel) params ["_pointWidth", "_pointHeight"];
                _ctrlPoint ctrlSetPosition [_xpos - _pointWidth/2, _ypos - _pointHeight/2, _pointWidth, _pointHeight];
                _ctrlPoint ctrlSetTextColor _color;
                _ctrlPoint ctrlShow true;
                _ctrlPoint ctrlCommit 0;
            }; 
        } forEach _values;

        // Reset the flag
        _scanlinesPending set [_scanlineID, false];
    };

    _scanlineID = _scanlineID+1;
};