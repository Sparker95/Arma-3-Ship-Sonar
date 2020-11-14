// Sets range mode of sonar

params ["_newRange"];

FLS_range = _newRange;
FLS_pingInterval = _newRange / 1500 * 2;
FLS_forceRefreshGrid = true;