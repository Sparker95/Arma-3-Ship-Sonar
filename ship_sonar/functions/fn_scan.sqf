#include "common.hpp"

/*
Scan the surface ahead.
*/

params [
        ["_veh", objNull, [objNull]],
        ["_sensorOffset", [], [[]]],
        ["_angleStart", 0, [0]],    // 0 ... 90
        ["_angleEnd", 0, [0]],      // 0 ... 90
        ["_angleResolution", 0, [0]],
        ["_maxDist", 0, [0]]
    ];

    #ifdef FLS_DEBUG
    diag_log format ["FLS: scan: %1", _this];
    #endif

// Beam width in degrees
private _beamWidth = 8;

// Establish coordinate system, as if our vehicle was perfectly horizontal
private _dir = direction _veh;
private _vecsFwdLocal = [];  // We alternate forward vectors a little to simulate beam width

ASP_SCOPE_START(makeRandomVectors);
for "_i" from 0 to 20 do {
    private _randomDir = -_beamWidth/2 + random _beamWidth;
    _vecsFwdLocal pushBack [sin (_randomDir), cos (_randomDir), 0];
};
ASP_SCOPE_END(makeRandomVectors);

// Prepare an array of angles to scan
private _angles = [];
private _angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _angleIncrement = (10*((sin _angle)^2) max 0.1);
    _angle = _angle + _angleIncrement;
    _angles pushBack _angle;
};

// Prepare an array of points to scan
ASP_SCOPE_START(prepareScanVectors);
private _positionsEndLocal = _angles apply 
{
    private _angle = _x;
    private _posEndLocal = ((selectRandom _vecsFwdLocal) vectorMultiply (_maxDist*(cos _angle)));
    _posEndLocal = _posEndLocal vectorAdd ([0, 0, 1] vectorMultiply (-_maxDist*(sin _angle)));
    [_angle, _posEndLocal];
};
#ifdef FLS_DEBUG
diag_log format ["FLS: prepareScanVectors:", _positionsEndLocal];
{
    diag_log format ["  %1", _x];
} forEach _positionsEndLocal;
#endif
private _posEndWorld = _posStartWorld;
ASP_SCOPE_END(prepareScanVectors);

// Prepare a transform which we will use to transform scan vectors according to needed rotation
private _posStartWorld = _veh modelToWorldWorld _sensorOffset;
private _transformObject = FLS_transformObject;
if (isNil "FLS_transformObject") then {
    _transformObject = "Sign_Arrow_F" createVehicleLocal [0,0,0];
    _transformObject hideObject true;
    FLS_transformObject = _transformObject;
};
_transformObject setPosWorld _posStartWorld;
_transformObject setDir _dir; // Will discard roll and pitch

// Scan all the angles in this vertical beam
private _raycastData = [];
ASP_SCOPE_START(scanAngles);
private _driver = driver _veh;
{ // forEach _angles;
    ASP_SCOPE_START(scanOneAngle);

    _x params ["_angle", "_posEndLocal"];

    ASP_SCOPE_START(transformVectors);
    private _posEndWorld = _transformObject modelToWorldWorld _posEndLocal;
    ASP_SCOPE_END(transformVectors);

    ASP_SCOPE_START(lineIntersectsSurfaces);
    private _intersections = lineIntersectsSurfaces [_posStartWorld, _posEndWorld, _veh, _driver, true, 1, "GEOM", "GEOM", false];
    ASP_SCOPE_END(lineIntersectsSurfaces);

    ASP_SCOPE_START(processRaycastResults);
    if (count _intersections > 0) then {
        private _posIntersectWorld = _intersections#0#0;
        private _vectorSurfaceNormal = _intersections#0#1;
        private _vectorPing = vectorNormalized (_posStartWorld vectorDiff _posEndWorld);
        private _cos = _vectorPing vectorCos _vectorSurfaceNormal; // Cos of angle between surface normal and ping vector
        //private _cos = 0.8;
        private _distance = _posStartWorld vectorDistance _posIntersectWorld;
        _raycastData pushBack [
            _angle,
            _posIntersectWorld,
            _distance,
            _cos
            #ifdef DEBUG
            ,
            _posStartWorld,
            _posEndWorld
            #endif
        ];
        /*
        #ifdef FLS_DEBUG
        diag_log format ["FLS: angle: %1, intersection: %2, distance: %3, cos: %4",
                            _angle,
                            _posIntersectWorld,
                            _distance,
                            _cos];
        #endif
        */
    };
    ASP_SCOPE_END(processRaycastResults);
    
    ASP_SCOPE_END(scanOneAngle);
} forEach _positionsEndLocal;
ASP_SCOPE_END(scanAngles);

#ifdef FLS_DEBUG
diag_log format ["FLS: scan: total points: %1", count  _raycastData];
#endif

#ifdef FLS_DEBUG
if (isNil "FLS_markers") then {
    FLS_markers = [];
};
{ deleteVehicle _x; } forEach FLS_markers;
FLS_markers = [];
{
    _x params ["_angle", "_posIntersect", "_distance", "_cos", "_posStart", "_posEnd"];
    private _arrow = "Sign_Arrow_F" createVehicle [0,0,0];
    _arrow setPosASL _posIntersect;
    FLS_markers pushBack _arrow;
    _arrow setVariable ["pos0AGL", ASLToAGL _posStart];
    _arrow setVariable ["pos1AGL", ASLToAGL _posIntersect];
} forEach _raycastData;

if (isNil "FLS_DebugPFH") then {
    FLS_DebugPFH = addMissionEventHandler ["Draw3D", {
        { 
            private _pos0 = _x getVariable "pos0AGL";
            private _pos1 = _x getVariable "pos1AGL";
            drawLine3D [
                _pos0,
                _pos1,
                [1,0,0,1]];
        } forEach FLS_markers;
    }];
};
#endif

// Return
_raycastData;