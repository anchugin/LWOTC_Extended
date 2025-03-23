class FBcreatures extends X2Character_DefaultCharacters config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;


	Templates.AddItem(CreateTemplate_SHIV_M11tank());
	Templates.AddItem(CreateTemplate_fbacv());
	

	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_SHIV_M11tank()
{ 
	local X2CharacterTemplate CharTemplate;


	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'fbacvplayer');

	CharTemplate.CharacterGroupName = 'fbacvplayer';
	CharTemplate.DefaultLoadout='acv_Loadoutplayer';
	CharTemplate.BehaviorClass=class'XGAIBehavior';


	
	CharTemplate.strPawnArchetypes.AddItem("fbnewgarbage.ARC_GameUnit_acvfinal");



	//CharTemplate.strMatineePackage = "CIN_Muton"; 
	//CharTemplate.strMatineePackages.AddItem("CIN_Muton"); //update with new cinematic?

	CharTemplate.UnitSize = 3;
	CharTemplate.UnitHeight = 4;


	

	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = false;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = true;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bStaffingAllowed = true;    
	CharTemplate.bAppearInBase = false;
	CharTemplate.bUsesWillSystem = false;
	CharTemplate.bIsTooBigForArmory = true;
	CharTemplate.bAllowRushCam = false;
		


	CharTemplate.bCanTakeCover = false; //!
	CharTemplate.bDiesWhenCaptured = true;
	
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false; 
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = true; //will be true when implementing into game
	//CharTemplate.bIsTurret = true;
	CharTemplate.bIsMeleeOnly = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;

	//CharTemplate.Abilities.AddItem('SHIV_M1Immunities');
	CharTemplate.Abilities.AddItem('acvevac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	CharTemplate.Abilities.AddItem('Interact_UseElevator');
	//CharTemplate.ImmuneTypes.AddItem('Mental');
	//CharTemplate.Abilities.AddItem('ChosenImmunities');
	//CharTemplate.Abilities.AddItem('HunterGrapple');
	
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.Abilities.AddItem('fbacvInitialState');

	CharTemplate.Abilities.AddItem('SectopodNewTeamState');
	CharTemplate.Abilities.AddItem('avengercleanup');
	//CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	CharTemplate.Abilities.AddItem('teleporttank');
	CharTemplate.Abilities.AddItem('tankunblocker');


	
	
	CharTemplate.Abilities.AddItem('tankvent1to0');
	CharTemplate.Abilities.AddItem('tankvent2to1');
	CharTemplate.Abilities.AddItem('tankvent3to2');
	CharTemplate.Abilities.AddItem('tankvent4to3');

	CharTemplate.Abilities.AddItem('tankvent5to4');
	

	/// 1 point heat
	CharTemplate.Abilities.AddItem('tankoverheat1');
	CharTemplate.Abilities.AddItem('tankoverheat2');
	CharTemplate.Abilities.AddItem('tankoverheat3');
	CharTemplate.Abilities.AddItem('tankoverheat4');

	CharTemplate.Abilities.AddItem('tankoverheat5');
	/// 2 point heat
	CharTemplate.Abilities.AddItem('tankoverheat1x2');
	CharTemplate.Abilities.AddItem('tankoverheat2x2');
	CharTemplate.Abilities.AddItem('tankoverheat3x2');
	CharTemplate.Abilities.AddItem('tankoverheat4x2');

	CharTemplate.Abilities.AddItem('tankoverheat5x2');

	///3
	CharTemplate.Abilities.AddItem('tankoverheat1x3');
	CharTemplate.Abilities.AddItem('tankoverheat2x3');
	CharTemplate.Abilities.AddItem('tankoverheat3x3');

	///shutdown
	CharTemplate.Abilities.AddItem('tankventshutdown');
	CharTemplate.Abilities.AddItem('tankventshutdown2');

	

	

	CharTemplate.strMatineePackages.AddItem("CIN_Spark");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	//CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	//CharTemplate.strIntroMatineeSlotPrefix = "Char";
	//CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";

	CharTemplate.strIntroMatineeSlotPrefix = "Spark";
	//CharTemplate.strLoadingMatineeSlotPrefix = "SparkSoldier";

	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.KnockbackDamageType);

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien; //this is wrong for SHIV


	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_Spark';
	CharTemplate.UICustomizationMenuClass = class'UICustomize_SparkMenu';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_SparkInfo';
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_SPARK';

	return CharTemplate;
}



static function int HighestSoldierRank()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int idx, maxRank, thisRank;

	maxRank = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	for(idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
		thisRank = UnitState.GetRank();
		if (thisRank > maxRank) maxRank = thisRank;
	}
	return maxRank;
}

// LevelUpBarracks is wrong, taken from here instead:
// X2StrategyElement_DefaultRewards::GeneratePersonnelReward
static function RankUpAlien(int maxRank, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local int i, j;
	local X2SoldierClassTemplate SoldierTemplate;
	local name AbilityName;

	`log ("rankup " @ maxRank @ " for " @ UnitState.GetLastName());
	SoldierTemplate = UnitState.GetSoldierClassTemplate();
	UnitState.SetXPForRank(maxRank);
	UnitState.StartingRank = maxRank;
	for (i=0; i<maxRank; i++)
	{
		if (i == 0)
		{
			// Rank up to squaddie
			`log ("rankup start");
			UnitState.RankUpSoldier(NewGameState, SoldierTemplate.DataName);
			UnitState.ApplySquaddieLoadout(NewGameState);
			for (j=0; j<SoldierTemplate.GetStatProgression(0).Length; ++j)
			{
				UnitState.BuySoldierProgressionAbility(NewGameState, 0, j);
			}
		}
		else
		{
			`log ("advanced rankup");
			UnitState.RankUpSoldier(NewGameState, UnitState.GetSoldierClassTemplate().DataName);
		}
	}
	`log ("rankup finished");
}




static function X2CharacterTemplate CreateTemplate_fbacv()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'fbacv');
	CharTemplate.CharacterGroupName = 'Sectopod';
	CharTemplate.DefaultLoadout='acv_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("fbnewgarbage.ARC_GameUnit_acvfinal");
	Loot.ForceLevel=0;
	Loot.LootTableName='tankstuffloot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Gatekeeper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Gatekeeper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	
	CharTemplate.strBehaviorTree="fbacv::CharacterRoot";

	CharTemplate.UnitSize = 3;
	CharTemplate.UnitHeight = 4;

	CharTemplate.KillContribution = 2.0;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = false;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = true;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bSkipDefaultAbilities = true;
	CharTemplate.bHideInShadowChamber = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	//CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "SkipMove";


	CharTemplate.ImmuneTypes.AddItem('Fire');
	//CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	
	
	//CharTemplate.Abilities.AddItem('soldaialerted');
	CharTemplate.Abilities.AddItem('StandardMove');
	//CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('fbacvInitialState');
	CharTemplate.Abilities.AddItem('SectopodNewTeamState');
	CharTemplate.Abilities.AddItem('avengercleanup');

	

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	

	return CharTemplate;
}





