// Called when toggle action is chosen

if (FLS_active) then {
    [false] call FLS_fnc_setPower;
} else {
    [true] call FLS_fnc_setPower;
};