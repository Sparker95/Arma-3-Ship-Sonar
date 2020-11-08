#include "common.hpp"

// Finds where a sensor is attached on a vehicle
// Returns position in vehicle space

params [
        ["_veh", objNull, [objNull]]
    ];

private _bbox = boundingBoxReal _veh;
_bbox params ["_bb0", "_bb1"];
private _bbottom = (_bb0#2) min (_bb1#2);
private _btop = (_bb0#2) max (_bb1#2);
private _posStart = _veh modelToWorldWorld [0, 0, _bbottom]; // Under the ship somewhere
private _posEnd = _veh modelToWorldWorld [0, 0, _btop];

private _intersections = lineIntersectsSurfaces [_posStart, _posEnd, objNull, objNull, true, 100, "VIEW", "FIRE", false];

#ifdef FLS_DEBUG
{
    diag_log format ["FLS: findSensorPos %1: %2", _forEachIndex, _intersections];
} forEach _intersections;
#endif

// Default if nothing was found
private _return = [0, 0, 0];
{
    _x params ["_intersectPosASL", "_surfaceNormal", "_intersectObject", "_parentObject"];
    if (_intersectObject isEqualTo _veh) exitWith {
        _return = _veh worldToModel (ASLToAGL _intersectPosASL);
    };
} forEach _intersections;

_return;