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

// Establish coordinate system,
// As if our vehicle was perfectly horizontal
private _dir = direction _veh;
// We alternate forward vectors a little to simulate beam width
private _vecsFwd = [];

for "_i" from 0 to 20 do {
    private _randomDir = _dir - _beamWidth/2 + random _beamWidth;
    _vecsFwd pushBack [sin (_randomDir), cos (_randomDir), 0];
};

private _vecUp = [0, 0, 1];

private _raycastData = [];

private _posStartWorld = _veh modelToWorldWorld _sensorOffset;
private _angle = _angleStart;
while {_angle < _angleEnd} do { 
    private _posEndWorld = _posStartWorld;
    _posEndWorld = _posEndWorld vectorAdd ((selectRandom _vecsFwd) vectorMultiply (_maxDist*(cos _angle)));
    _posEndWorld = _posEndWorld vectorAdd (_vecUp vectorMultiply (-_maxDist*(sin _angle)));
    private _intersections = lineIntersectsSurfaces [_posStartWorld, _posEndWorld, _veh, driver _veh, true, 1, "VIEW", "FIRE", false];

    if (count _intersections > 0) then {
        private _posIntersectWorld = _intersections#0#0;
        private _vectorSurfaceNormal = _intersections#0#1;
        private _vectorPing = (_posStartWorld vectorDiff _posEndWorld);
        private _cos = _vectorPing vectorCos _vectorSurfaceNormal; // Cos of angle between surface normal and ping vector
        private _distance = _posStartWorld vectorDistance _posIntersectWorld;
        _raycastData pushBack [
            _angle,
            _posIntersectWorld,
            _distance,
            _cos,
            _posStartWorld,
            _posEndWorld
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
    private _angleIncrement = (10*((sin _angle)^2) max 0.1);
    _angle = _angle + _angleIncrement;
};

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