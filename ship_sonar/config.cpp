class CfgPatches
{
	class sparker_ship_sonar
	{
		// Meta information for editor
		name = "Ship Sonar";
		author = "Sparker";
		url = "";

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
            class findSensorPos {  };
            class scan {  };
            class updateBasicFLS {  };
            class updateSectorSonar {  };
            class onEachFrame {  };
            class preInit { preInit = 1;  };
            class addAction {  };
            class setRange {};
            class setMode {};
            class setPower {};
            class createPanelForMode {};
            class updateColorLUT {};

            // Graph plotter control
            class ui_graphCreate {  };
            class ui_graphDelete {  };
            class ui_graphToUI { headerType = -1; };

            class ui_graphPlotData {  };
            class ui_graphPlotAxes {  };
            class ui_graphUpdateLables {  };
            class ui_graphRefresh {  };

            class ui_graphSetDataValues {  };
            class ui_graphSetLimits {  };
            class ui_graphSetGridStep {  };

            // Polar graph plotter control
            class ui_graphPolarCreate {  };
            class ui_graphPolarDelete {  };
            class ui_graphPolarRefresh {  };
            class ui_graphPolarSetScanline {  };
            class ui_graphPolarSetLimit {  };

            // Whole panel
            class ui_panelCreate {  };
            class ui_panelPolarCreate {  };
            class ui_panelPolarDrawGradient {};
            class ui_panelDelete {  };

            // Settings panel
            class ui_createSettingsPanel {  };
            class ui_createComboBox {  };
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