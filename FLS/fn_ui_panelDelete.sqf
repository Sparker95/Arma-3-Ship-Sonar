params ["_panelControl"];

private _graph = _panelControl getVariable "FLS_graph";
if (!isNil "_graph") then {
    [_graph] call FLS_ui_fnc_graphDelete;
};
ctrlDelete _panelControl;