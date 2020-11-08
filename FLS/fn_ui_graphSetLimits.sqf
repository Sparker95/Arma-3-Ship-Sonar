#include "common.hpp"

/*
Sets limits of data
*/

params ["_ctrlGroup", "_xlim", "_ylim"];

#ifdef FLS_DEBUG
diag_log format ["FLS: set graph limits: %1", _this];
#endif

_ctrlGroup setVariable ["xlim", _xlim];
_ctrlGroup setVariable ["ylim", _ylim];