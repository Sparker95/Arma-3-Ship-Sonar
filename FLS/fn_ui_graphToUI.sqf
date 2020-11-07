#include "common.hpp"

// Converts coordinates from graph space to UI space
params ["_ctrl", "_x", "_y"];

[
    (_ctrl getVariable "plotOriginX") +
    (_ctrl getVariable "plotWidth") * _x / (_ctrl getVariable "xlim"),

    (_ctrl getVariable "plotOriginy") +
    (_ctrl getVariable "plotHeight") * _y / (_ctrl getVariable "ylim")
];