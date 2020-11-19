#include "common.hpp"

/*
Scan the surface ahead.
*/

params [
        ["_veh", objNull, [objNull]],
        ["_dirOffset", 0, [0]], // Direction offset from vehicle's bearing
        ["_maxDist", 0, [0]],
        ["_sensorOffset", [], [[]]],
        ["_positionsEndLocal", [], [[]]]
    ];

    #ifdef FLS_DEBUG
    diag_log format ["FLS: scan: %1", _this];
    #endif

// Establish coordinate system, as if our vehicle was perfectly horizontal
private _dir = (direction _veh) + _dirOffset;

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
{ // forEach _positionsEndLocal;
    ASP_SCOPE_START(scanOneAngle);

    _x params ["_angle", "_posEndLocal"];

    ASP_SCOPE_START(transformVectors);
    private _posEndWorld = _transformObject modelToWorldWorld (_posEndLocal vectorMultiply _maxDist);
    ASP_SCOPE_END(transformVectors);

    ASP_SCOPE_START(lineIntersectsSurfaces);
    private _intersections = lineIntersectsSurfaces [_posStartWorld, _posEndWorld, _veh, _driver, true, 1, "GEOM", "GEOM", false];
    ASP_SCOPE_END(lineIntersectsSurfaces);

    ASP_SCOPE_START(processRaycastResults);
    if (count _intersections > 0) then {
        (_intersections#0) params ["_posIntersectWorld", "_vectorSurfaceNormal", "_object"];
        private _vectorPing = vectorNormalized (_posStartWorld vectorDiff _posEndWorld);
        private _cos = _vectorPing vectorCos _vectorSurfaceNormal; // Cos of angle between surface normal and ping vector
        if (isNull _object) then {
            _cos = _cos*(random 1);// + 0.07;
        } else {
            _cos = 1.3*_cos + 0.0;
        };
        private _distance = _posStartWorld vectorDistance _posIntersectWorld;
        _raycastData pushBack [
            _angle,
            _distance,
            _cos
            #ifdef FLS_DEBUG
            ,_posIntersectWorld,
            _posStartWorld,
            _posEndWorld
            #endif
        ];
        
        #ifdef FLS_DEBUG
        diag_log format ["FLS: angle: %1, intersection: %2, distance: %3, cos: %4",
                            _angle,
                            _posIntersectWorld,
                            _distance,
                            _cos];
        #endif
        
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
    _x params ["_angle", "_distance", "_cos", "_posIntersect", "_posStart", "_posEnd"];
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