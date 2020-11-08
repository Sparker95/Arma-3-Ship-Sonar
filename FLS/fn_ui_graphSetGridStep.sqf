#include "common.hpp"

/*
Sets steps for the grid
*/

params ["_ctrlGroup", "_xstep", "_ystep"];

_ctrlGroup setVariable ["ax_xstep", _xstep];
_ctrlGroup setVariable ["ax_ystep", _ystep];