class X2EventListener_Augmentations_Strategy extends X2EventListener config (Augmentations);

var config bool bUseGravelyWoundedMechanic;
var config int GRAVELY_WOUNDED_NEEDS_AUGMENATION_CHANCE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateOverrideHasHeavyWeaponListenerTemplate());
	Templates.AddItem(CreatePostMissionUpdateSoldierHealingListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateOverrideHasHeavyWeaponListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AugmentationsOnOverrideHasHeavyWeapon');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideHasHeavyWeapon', OnOverrideHasHeavyWeapon, ELD_Immediate);
	`LOG("Register Event OnOverrideHasHeavyWeapon",, 'RPG');

	return Template;
}

static function CHEventListenerTemplate CreatePostMissionUpdateSoldierHealingListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AugmentationsOnPostMissionUpdateSoldierHealing');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('PostMissionUpdateSoldierHealing', OnPostMissionUpdateSoldierHealing, ELD_Immediate);
	`LOG("Register Event OnPostMissionUpdateSoldierHealing",, 'RPG');

	return Template;
}


static function EventListenerReturn OnOverrideHasHeavyWeapon(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Unit	UnitState;
	local XComGameState			CheckGameState;
	local bool bOverrideHasHeavyWeapon, bHasHeavyWeapon;
	local XComGameState_Item	ItemState;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnOverrideHasHeavyWeapon event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	bOverrideHasHeavyWeapon = OverrideTuple.Data[0].b;
	bHasHeavyWeapon = OverrideTuple.Data[1].b;
	UnitState = XComGameState_Unit(EventSource);
	CheckGameState = XComGameState(OverrideTuple.Data[2].o);

	if (UnitState == none)
	{
		return ELR_NoInterrupt;
	}

	ItemState = UnitState.GetItemInSlot(eInvSlot_AugmentationArms, CheckGameState);
	if (ItemState != none)
	{
		bHasHeavyWeapon = ItemState.GetMyTemplateName() == 'AugmentationArms_Launcher_BM';
		bOverrideHasHeavyWeapon = bHasHeavyWeapon;

		OverrideTuple.Data[0].b = bOverrideHasHeavyWeapon;
		OverrideTuple.Data[1].b = bHasHeavyWeapon;

		`LOG(GetFuncName() @ bOverrideHasHeavyWeapon @ bHasHeavyWeapon,, 'Augmentations');
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnPostMissionUpdateSoldierHealing(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Unit	UnitState;
	local int Random;
	local int RandRoll;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnPostMissionUpdateSoldierHealing event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	OverrideTuple.Data[0].b = true;

	UnitState = XComGameState_Unit(EventSource);

	if (
		class'X2StrategyElement_AugmentationSlots'.default.CharacterTemplateBlacklist.Find(UnitState.GetMyTemplateName()) != INDEX_NONE ||
		class'X2StrategyElement_AugmentationSlots'.default.CharacterClassBlacklist.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE ||
		!default.bUseGravelyWoundedMechanic
	) {
		return ELR_NoInterrupt;
	}

	// Prevent gravely units from healing and randomly determine a severed body part that needs to be augmented
	if (UnitState != none && UnitState.IsGravelyInjured())
	{
		RandRoll = `SYNC_RAND_STATIC(100);

		if (RandRoll <= default.GRAVELY_WOUNDED_NEEDS_AUGMENATION_CHANCE)
		{
			Random = Rand(4);

			if ((Random == eHead && UnitState.GetItemInSlot(eInvSlot_AugmentationHead) == none) ||
				(Random == eTorso && UnitState.GetItemInSlot(eInvSlot_AugmentationTorso) == none) ||
				(Random == eArms && UnitState.GetItemInSlot(eInvSlot_AugmentationArms) == none) ||
				(Random == eLegs && UnitState.GetItemInSlot(eInvSlot_AugmentationLegs) == none))
			{
				OverrideTuple.Data[0].b = false; // disable the healing project
				`LOG(GetFuncName() @ "SeveredBodyPart" @ GetEnum(Enum'ESeveredBodyPart', Random),,'Augmentations');
				UnitState = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				UnitState.SetUnitFloatValue('SeveredBodyPart', float(Random), eCleanup_Never);
			}
		}
	}

	return ELR_NoInterrupt;
}