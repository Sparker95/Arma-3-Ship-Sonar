class CfgPatches
{
	class sparker_ship_sonar
	{
		// Meta information for editor
		name = "Ship Sonar";
		author = "Sparker";
		url = "https://youtu.be/cvh0nX08nRw";

		// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
		requiredVersion = 1.60; 
		
		requiredAddons[] = { "A3_Boat_F" };
		
		// List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
		units[] = {};
		// List of weapons (CfgWeapons classes) contained in the addon.
		weapons[] = {};
	};
};

#define _HEADER

class CfgFunctions {
	class FLS
	{
        class FLS {
            file = "ship_sonar\functions";

            // Scanning ang other functions
            class findSensorPos { _HEADER };
            class scan { _HEADER };
            class update { _HEADER };
            class onEachFrame { _HEADER };
            class preInit { preInit = 1; _HEADER };
            class activate { _HEADER };
            class deactivate { _HEADER };
            class actionToggle { _HEADER };

            // Graph plotter control
            class ui_graphCreate { _HEADER };
            class ui_graphDelete { _HEADER };
            class ui_graphToUI { _HEADER };

            class ui_graphPlotData { _HEADER };
            class ui_graphPlotAxes { _HEADER };
            class ui_graphUpdateLables { _HEADER };
            class ui_graphRefresh { _HEADER };

            class ui_graphSetDataValues { _HEADER };
            class ui_graphSetLimits { _HEADER };
            class ui_graphSetGridStep { _HEADER };

            // Whole panel
            class ui_panelCreate { _HEADER };
            class ui_panelDelete { _HEADER };
        };
	};
};

/*
class CfgVehicles {
	class Ship;
	class Ship_F : Ship {
		class UserActions
		{
			class toggle_sonar
			{
				//displayName = "<img image='\someAddon\images\icon1.paa' size='1' shadow='false' /> Show HUD";
				//displayNameDefault = "<img image='\someAddon\images\icon1.paa' size='3' shadow='false' />";
				displayName = "Toggle Sonar";
				displayNameDefault = "Toggle Sonar";
				priority = 3;
				radius = 20;
				position = "";
				showWindow = 0;
				hideOnUse = 0;
				onlyForPlayer = 1;
				shortcut = "";
				condition = "driver this == player";
				statement = "call FLS_fnc_actionToggle;";
			};
		};
	};
};
*/