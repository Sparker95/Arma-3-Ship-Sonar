class CfgPatches
{
	class ShipSonar
	{
		// Meta information for editor
		name = "Ship Sonar";
		author = "Sparker";
		url = "https://youtu.be/cvh0nX08nRw";

		// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
		requiredVersion = 1.60; 
		
		requiredAddons[] = { "A3_Data_F" };
		
		// List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
		units[] = {};
		// List of weapons (CfgWeapons classes) contained in the addon.
		weapons[] = {};
	};
};

class CfgVehicles {
	class Ship;
	class Ship_F : Ship {
		class UserActions
		{
			class stuff
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
				condition = "true";
				statement = "player setdamage 1;";
			};
		};
	};
};