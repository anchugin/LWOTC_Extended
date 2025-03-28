class X2StrategyElement_FacilityUpgrade_AWC_Custom extends X2StrategyElement_DefaultFacilityUpgrades;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Upgrades;

	// Infirmary
	Upgrades.AddItem(CreateInfirmary_GeneModChamberTemplate());

	return Upgrades;
}

//---------------------------------------------------------------------------------------
// INFIRMARY UPGRADES
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInfirmary_GeneModChamberTemplate()
{
	local X2FacilityUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'Infirmary_GeneModdingChamber');
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.ChooseFacility_Infirmary_Hypervital_Module";
	Template.OnUpgradeAddedFn = OnUpgradeAdded_UnlockGeneModdingStaffSlots;

	// Stats
	Template.iPower = -2;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

function OnUpgradeAdded_UnlockGeneModdingStaffSlots(XComGameState NewGameState, XComGameState_FacilityUpgrade Upgrade, XComGameState_FacilityXCom Facility)
{
	local XComGameState_StaffSlot StaffSlotState;
	local int i;

	for (i = 0; i < Facility.StaffSlots.Length; i++)
	{
		StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(Facility.StaffSlots[i].ObjectID));
		if (StaffSlotState.IsLocked() && StaffSlotState.GetMyTemplateName() == 'GeneModdingChamberSoldierStaffSlot')
		{
			StaffSlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', Facility.StaffSlots[i].ObjectID));
			StaffSlotState.UnlockSlot();
		}
	}
}
