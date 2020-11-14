#include "common.hpp"

// Sets data for one scanline

params ["_ctrlGroup", "_scanlineID", "_values"];

private _plotScanlinesData = _ctrlGroup getVariable "plotScanlinesData";
private _plotScanlinesPending = _ctrlGroup getVariable "plotScanlinesPending";

_plotScanlinesData set [_scanLineID, _values];
_plotScanlinesPending set [_scanlineID, true];

// That's all, we refresh it in another call