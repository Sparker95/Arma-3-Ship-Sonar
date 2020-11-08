#include "common.hpp"

// Updates text of lables according to limit values

params ["_ctrlGroup"];

private _xlim = _ctrlGroup getVariable "xlim";
private _ylim = _ctrlGroup getVariable "ylim";

private _xlable = _ctrlGroup getVariable "xlable";
private _xlablemid = _ctrlGroup getVariable "xlablemid";
private _ylable = _ctrlGroup getVariable "ylable";
private _ylablemid = _ctrlGroup getVariable "ylablemid";

private _formatMeters = { format ["%1M", round _this]; };

_xlable ctrlSetText ((_xlim) call _formatMeters);
_xlablemid ctrlSetText ((_xlim/2) call _formatMeters);
_ylable ctrlSetText ((_ylim) call _formatMeters);
_ylablemid ctrlSetText ((_ylim/2) call _formatMeters);