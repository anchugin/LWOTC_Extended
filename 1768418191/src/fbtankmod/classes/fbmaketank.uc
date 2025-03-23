//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultTechs.uc
//  AUTHOR:  Fireborn the Coyote
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 DinoDicks, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class fbmaketank extends X2StrategyElement config(GameData);

var config int FBSupplycostx;
var config int FBalloycostx;
var config int FBpartcostx;
var config int FBcorecostx;
var config int FBbuildtimex;
var config int FBsciencescorex;
var config int FBengineeringscorex;



static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;



	Techs.AddItem(makeshivTemplate33tank());


	return Techs;
}




static function X2DataTemplate makeshivTemplate33tank()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'intshiv22tank');
	Template.bRepeatable = true;
	Template.PointsToComplete = default.FBbuildtimex;
	Template.bProvingGround = true;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.challenge_Sectopod";
	
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');
	Template.Requirements.RequiredScienceScore = default.FBsciencescorex;
	Template.Requirements.RequiredEngineeringScore = default.FBengineeringscorex;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	Template.ResearchCompletedFn = ResearchCompletedfbbgtank;
	
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.FBSupplycostx;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.FBalloycostx;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = default.FBcorecostx;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName='EleriumCorefbbtank';
	Resources.Quantity= default.FBpartcostx;
	Template.Cost.ResourceCosts.AddItem(Resources);


	
	return Template;
}



function ResearchCompletedfbbgtank(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	`log("research");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	UnitState = CreateUnitvipttank(NewGameState);
	NewGameState.AddStateObject(UnitState);
	
	XComHQ.AddToCrew(NewGameState, UnitState);
	UnitState.SetHQLocation(eSoldierLoc_Barracks);
	XcomHQ.HandlePowerOrStaffingChange(NewGameState);
	`log("attackattack-return");
}


static function XComGameState_Unit CreateUnitvipttank(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local X2CharacterTemplateManager CharTemplateManager;
	local X2CharacterTemplate CharTemplate;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item ItemState;
	local XGCharacterGenerator CharGen;
	local string strFirst, strLast;
	local int maxRank;
	

	`log("makinghim");
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	CharTemplate = CharTemplateManager.FindCharacterTemplate('fbacvplayer');
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);




	





		//ItemTemplate = ItemTemplateManager.FindItemTemplate('Cannon_SHIV_M11');
		//ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		//UnitState.AddItemToInventory(ItemState, eInvSlot_PrimaryWeapon, NewGameState);
		//NewGameState.AddStateObject(ItemState);
		//if (XComHQ.GetNumItemInInventory('Cannon_SHIV_M11') == 0)
		//	XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	






		
	//CharGen = `XCOMGAME.spawn( class 'XGCharacterGenerator' );
	CharGen = `XCOMGAME.spawn( class 'fbtankname' );
	CharGen.GenerateName(0, 'Country_fbshiv6667tank', strFirst, strLast);
	UnitState.SetCharacterName(strFirst, strLast, "");
	`log("debys-name " @ strFirst @ " " @ strLast);
	UnitState.SetCountry('Country_fbshiv6667tank');
	
	NewGameState.AddStateObject(UnitState);
	UnitState.SetSkillLevel(7);
	UnitState.SetSoldierClassTemplate('fbshivclasshtank');
	
	class'fbcreatures'.static.RankUpAlien(1, UnitState, NewGameState);
	
	UnitState.kAppearance.iGender = 1;
	UnitState.StoreAppearance();
	return UnitState;
}





