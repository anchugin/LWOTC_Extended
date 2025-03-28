class X2DownloadableContentInfo_WOTCJetPacks extends X2DownloadableContentInfo;

/*
Rough outline for overhauled abilities:
Booster Jets:
- Flight + Emergency Evac + Crater (only with HSM/PSM): share 1 charge.
- Jet Jump + Jet Shot + Rocket Punch (only with HSM/PSM): share 5 charges. Jet Jump will be a new ability that works similarly to Force Jump Musashi made for Jedis, where the soldier "flies" point-to-point on a grenade-like arched trajectory. Making it a grapple-like straight flight is the backup plan. Jet Jump is a free action, but can be used once per turn.
Crater will now use HSM/PSM to slam the ground as the soldier lands. It will still be an Area of Effect attack. 
Rocket Punch will work mechanically similar to Skirmisher's Wrath, where the soldier flies to the target, and then uses HSM/PSM to smack the target, single target.
Elerium Jets will work the same, but with the double amount of charges.
Also thinking of making it possible to use Emergency Evac while carrying other soldiers.
Should then make it work with Flight as well, probably.
A bit worried about icon bloat, but meh whatever.
IridarToday at 6:29 AM
TOOD: Solve icon bloat by adding Toggle Jets button.
SPARKs abilities with Jet Packs are to be determined, but rough outline is: Flight, Emergency Evac, their own version of Crater where they break through ceilings to land on the floor level. Most likely no Jet Shot. Unsure about Jet Jump and Rocket Punch.
If I'm successful at making the SPARK transform into something decent while using Flight, then I also want to try my hand at a Strafing Run sort of ability, where it transform into a plane and delivers a Height Advantage'd primary weapon attack to a specified target.
I also wanna try adding a cinematic where soldiers/spark run off Skyranger's ramp while doing dynamic deployment.

Remove Elerium Jets item,
*/

/*
Socket names used by Jet Packs:
FX_Forearm_R
FX_Ground_Pound

FX_LShin
FX_RShin

FX_JetPack_R
FX_JetPack_L

FX_JumpKit_R
FX_JumpKit_L
*/

var config(JetPacks) bool BLOCK_ABILITIES_WHILE_FLYING;
var config(JetPacks) array<name> ABILITIES_ALLOWED_WHILE_FLYING;
var config(JetPacks) array<name> SHOOTING_ABILITIES_ALLOWED_WHILE_FLYING;
var config(JetPacks) array<name> DUAL_WEAPON_CATEGORIES;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2DataTemplate AbilityDataTemplate;
	local X2AbilityTemplate Ability;
	local UIScreenListener CDO;
	local CHHelpers CHHelpersObj;

	//	Add Dynamic Deployment GTS perk, unless standalone mod for that is present.
	if (!IsModActive('WOTCIridarDynamicDeployment'))
	{
		AddAssaultPerkGTSTemplate();
	}
	else
	{
		// Kill our UISL
		CDO = UIScreenListener(class'XComEngine'.static.GetClassDefaultObjectByName(name("WOTCJetPacks.UIScreenListener_AddGTSPerks")));
		if (CDO != none)
		{	
			CDO.ScreenClass = class'UIScreen_Dummy';
		}
	}
	
	//	patch abilities for Jet Shot
	if(default.BLOCK_ABILITIES_WHILE_FLYING)
	{
		//	Grab all ability templates
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		foreach AbilityTemplateManager.IterateTemplates(AbilityDataTemplate, none)
		{
			//	Go through all abilities
			Ability = X2AbilityTemplate(AbilityDataTemplate);
			if (Ability != none)
			{
				if(default.ABILITIES_ALLOWED_WHILE_FLYING.Find(Ability.DataName) == INDEX_NONE && default.SHOOTING_ABILITIES_ALLOWED_WHILE_FLYING.Find(Ability.DataName) == INDEX_NONE)	// If the ability is not whitelisted
				{
					//	If the ability doesn't play an activating animation, is passive or doesn't have a build viz function, then we skip it
					// add a check for Skip Exit Cover?
					if (Ability.bSkipFireAction || Ability.bIsPassive || Ability.BuildVisualizationFn == none || !Ability.HasTrigger('X2AbilityTrigger_PlayerInput')) continue;	//thanks for the latter, Musashi-sensei
					//	Otherwise we attach to it a condition that prevents it from being used while Jet Shot is active
					Ability.AbilityShooterConditions.AddItem(new class'X2Condition_IRI_JetShot');
				}
				else 
				{	
					//	If the ability is whitelisted to be used with Jet Shot, we attach a condition that allows that ability to be used only while the soldier has a clear sky above their head
					if(default.SHOOTING_ABILITIES_ALLOWED_WHILE_FLYING.Find(Ability.DataName) != INDEX_NONE) 
					{	
						//	This condition will also prevent the ability from being used if it's not attached to a primary weapon.
						Ability.AbilityShooterConditions.AddItem(new class'X2Condition_IRI_RoofClearance');
						Ability.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_JetShotVisibility');

						//	if Jet Shot is set up to use charges, then we also add a condition that will prevent the ability from being activated if Jet Shot doesn't have enough charges
						if (class'X2Ability_IRI_JetPacks'.default.JET_SHOT_CHARGES > 0 && Ability.DataName != 'IRI_JetShot_Cancel') // leaving out Jet Shot cancel so you can still cancel Jet Shot even if Jet Shot is out of charges (duh)
						{
							Ability.AbilityShooterConditions.AddItem(new class'X2Condition_IRI_JetShot_Charges');
						}
					}
				}
			}
		}
	}

	//------------------- 2023

    CHHelpersObj = class'CHHelpers'.static.GetCDO();
    if (CHHelpersObj != none)
    {
        CHHelpersObj.AddOverrideHasHeightAdvantageCallback(OverrideHasHeightAdvantage);
    }
}	

static function AddAssaultPerkGTSTemplate() //GTS SKILL
{
  local X2StrategyElementTemplateManager templateManager;
  local X2FacilityTemplate Template;

  templateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

  Template = X2FacilityTemplate(templateManager.FindStrategyElementTemplate('OfficerTrainingSchool'));

  if (class'X2StrategyElement_IRI_GTSPerks'.default.ALLOW_DYNAMIC_DEPLOYMENT) {
      Template.SoldierUnlockTemplates.AddItem('IRI_UnlockDynamicDeployment'); //GTS SKILL
  }
}

static final function bool IsModActive(name ModName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        if (EventManager.GetDLCNames(Index) == ModName) 
        {
            return true;
        }
    }
    return false;
}

//	Add Jet Pack animations to soldiers
//	Has to be done through Highlander because otherwise animations would not work with Dynamic Deployment for some reason
static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local X2ArmorTemplate ArmorTemplate;
	local XComGameState_Item ArmorState;
	local bool DualWielding;

    if(!UnitState.IsSoldier())
    {
        return;
    }

	//	if the soldier has Jet Pack equipped, add main animset
    if (UnitState.HasItemOfTemplateType('IRI_JetBoosters_MK1') || UnitState.HasItemOfTemplateType('IRI_JetBoosters_MK2'))
    {
		//	If this is a SPARK
		if (UnitState.GetMyTemplate().UnitHeight > 2)
		{
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JetPacks.Anims.AS_JetPack_Spark")));
		}
		else
		{
			DualWielding = HasDualWeaponsEquipped(UnitState);

			if(DualWielding) CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JetPacks.Anims.AS_JetPack_DP")));
			else CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JetPacks.Anims.AS_JetPack")));
		
			//	Icarus Slam (Meteor) requires a separate animset because it must override the HL_TeleportStop animsequence
			//	Renaming it through code would require far too much work
			if (UnitState.HasSoldierAbility('IRI_IcarusSlam'))
			{
				//	if Icarus Slam is set up to work only for Heavy Armor
				if (class'X2Ability_IRI_JetPacks'.default.ICARUS_SLAM_ARMOR_RESTRICTION == 2)
				{
					ArmorState = UnitState.GetItemInSlot(eInvSlot_Armor);
					ArmorTemplate = X2ArmorTemplate(ArmorState.GetMyTemplate());
					//	and the soldier's armor doesn't provide Heavy Weapon inventory slot
					//	we don't apply the additional animset
					if (!ArmorTemplate.bHeavyWeapon) return;
				}
				if(DualWielding) CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JetPacks.Anims.AS_JetPack_DP_Heavy")));
				else CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JetPacks.Anims.AS_JetPack_Heavy")));
			}
		}
    }
}

static function bool HasDualWeaponsEquipped(XComGameState_Unit UnitState)
{
	local name PrimaryWeaponCat;

	//	get weapon category of the unit's primary weapon
	PrimaryWeaponCat = X2WeaponTemplate(UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon).GetMyTemplate()).WeaponCat;

	//	if secondary weapon doesn't have the same weapon category means we're not dual wielding (probably)
	if (PrimaryWeaponCat != X2WeaponTemplate(UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon).GetMyTemplate()).WeaponCat) return false;
	else 
	{
		if(default.DUAL_WEAPON_CATEGORIES.Find(PrimaryWeaponCat) != INDEX_NONE) return true;
		return false;
	}
}

static event InstallNewCampaign(XComGameState StartState)
{
	RemoveCosmetics();
}


//	this bit sets to zero the chance of randomly getting a soldier with jet pack cosmetics
static function RemoveCosmetics()
{
	local XComOnlineProfileSettings		ProfileSettings;
	local int Index;

	ProfileSettings = `XPROFILESETTINGS;
	for(Index = 0; Index < ProfileSettings.Data.PartPackPresets.Length; ++Index)
	{
		if(ProfileSettings.Data.PartPackPresets[Index].PartPackName == 'WOTCJetPacks')
		{
			ProfileSettings.Data.PartPackPresets[Index].ChanceToSelect = 0;
		}
	}
}


static event OnLoadedSavedGameToStrategy() 
{
	if (!IsResearchInHistory('JetBoosters_MK1_Tech')) AddJetPackTech('JetBoosters_MK1_Tech');
	if (!IsResearchInHistory('JetBoosters_MK2_Tech')) AddJetPackTech('JetBoosters_MK2_Tech');
	RemoveCosmetics();
}

static event OnLoadedSavedGame()
{
	if (!IsResearchInHistory('JetBoosters_MK1_Tech')) AddJetPackTech('JetBoosters_MK1_Tech');
	if (!IsResearchInHistory('JetBoosters_MK2_Tech')) AddJetPackTech('JetBoosters_MK2_Tech');
	RemoveCosmetics();
}

static function AddJetPackTech(name TechName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2StrategyElementTemplateManager StrategyElementTemplateManager;
	local XComGameState_Tech TechState;
	local X2TechTemplate TechTemplate;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Jet Pack Techs");
	StrategyElementTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	TechTemplate = X2TechTemplate(StrategyElementTemplateManager.FindStrategyElementTemplate(TechName));

	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	History.AddGameStateToHistory(NewGameState);
}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}

static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
    local X2WeaponTemplate		Template, SecondaryTemplate;
    local XComGameState_Unit	UnitState;
    Local XComGameState_Item	InternalWeaponState;
	local XComGameStateHistory	History;
	local XComContentManager	Content;

	History = `XCOMHISTORY;
    
    if (ItemState == none)
    {
        InternalWeaponState = XComGameState_Item(History.GetGameStateForObjectID(WeaponArchetype.ObjectID));
    }
	else 
	{
		InternalWeaponState = ItemState;
	}
	if (InternalWeaponState != none && InternalWeaponState.InventorySlot == eInvSlot_PrimaryWeapon)
	{
		Template = X2WeaponTemplate(InternalWeaponState.GetMyTemplate());
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(InternalWeaponState.OwnerStateObject.ObjectID));

		//`LOG("Primary Weapon:" @ Template.DataName @ "initialized for: "@ UnitState.GetFullName() @ "has effect:" @ UnitState.IsUnitAffectedByEffectName(class'X2Effect_IRI_WeaponSpecificAnimSet'.default.EffectName),, 'IRIJET');

		if (UnitState != none && Template != none && UnitState.IsUnitAffectedByEffectName(class'X2Effect_IRI_WeaponSpecificAnimSet'.default.EffectName))
		{
			Content = `CONTENT;
			//	Get secondary weapon
			InternalWeaponState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon);
			if (InternalWeaponState != none)
			{
				SecondaryTemplate = X2WeaponTemplate(InternalWeaponState.GetMyTemplate());
			}
		
			//	Dual Pistols
			if (class'X2Ability_IRI_JetPacks'.default.DUAL_PISTOL_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE && SecondaryTemplate != none && Template.WeaponCat == SecondaryTemplate.WeaponCat)
			{
				//`LOG("Dual pistol animations assigned",, 'IRIJET');
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetShot_DualPistols.Anims.AS_JetShot_DualPistols")));
				Weapon.CustomUnitPawnAnimsetsFemale.Length = 0;
				Weapon.WeaponFireAnimSequenceName = 'FF_FireA';
				Weapon.WeaponFireKillAnimSequenceName = 'FF_FireA';
				return;
			}

			// Primary Pistol
			if (class'X2Ability_IRI_JetPacks'.default.PRIMARY_PISTOL_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE && (Template.WeaponCat != SecondaryTemplate.WeaponCat || SecondaryTemplate == none))
			{
				//`LOG("Primary pistol animations assigned",, 'IRIJET');

				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetShot_DualPistols.Anims.AS_JetShot_DualPistols")));
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetShot_DualPistols.Anims.AS_JetShot_PrimaryPistol")));
				Weapon.CustomUnitPawnAnimsetsFemale.Length = 0;
					
				Weapon.WeaponFireAnimSequenceName = 'FF_FireA';
				Weapon.WeaponFireKillAnimSequenceName = 'FF_FireA';
				return;
				
			}
			//	## Exit / Enter Cover replacement sequences
			Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetPacks.Anims.AS_JetShot")));	
			Weapon.CustomUnitPawnAnimsetsFemale.Length = 0;

			//	## Weapon-specific sequences
			//	Sniper Rifle
			if (class'X2Ability_IRI_JetPacks'.default.SNIPER_RIFLE_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE) 
			{	
				//`LOG("Sniper rifle animations assigned: " @ Weapon.WeaponFireAnimSequenceName,, 'IRIJET');
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetPacks.Anims.AS_JetShot_SniperRifle")));
				switch (Weapon.WeaponFireAnimSequenceName)
				{
					case 'FF_FireConv':
					case 'FF_FireMag':
					case 'FF_FireBeam':
					case 'FF_FirePlasma':
					case 'FF_FireConvA':
					case 'FF_FireMagA':
					case 'FF_FireBeamA':
					case 'FF_FirePlasmaA':
						Weapon.WeaponFireKillAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
						return;
					default:
						Weapon.WeaponFireAnimSequenceName = 'FF_FireMagA';
						Weapon.WeaponFireKillAnimSequenceName = 'FF_FireMagA';
						return;
				}
				return;
			}
			//	Assault Rifle
			if (class'X2Ability_IRI_JetPacks'.default.ASSAULT_RIFLE_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE) 
			{
				//`LOG("Assault rifle animations assigned",, 'IRIJET');
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetPacks.Anims.AS_JetShot_AR")));
				switch (Weapon.WeaponFireAnimSequenceName)
				{
					case 'FF_FireConv':
					case 'FF_FireMag':
					case 'FF_FireBeam':
					case 'FF_FirePlasma':
					case 'FF_FireChosen':
					case 'FF_FireConvA':
					case 'FF_FireMagA':
					case 'FF_FireBeamA':
					case 'FF_FirePlasmaA':
					case 'FF_FireChosenA':
						Weapon.WeaponFireKillAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
						return;
					default:
						Weapon.WeaponFireAnimSequenceName = 'FF_FireConvA';
						Weapon.WeaponFireKillAnimSequenceName = 'FF_FireConvA';
						return;
				}
				return;
			}
			//	Bullpup
			if (class'X2Ability_IRI_JetPacks'.default.BULLPUP_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE) 
			{
				//`LOG("Bullpup pistol animations assigned",, 'IRIJET');
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetPacks.Anims.AS_JetShot_Bullpup")));
				switch (Weapon.WeaponFireAnimSequenceName)
				{
					case 'FF_FireConv':
					case 'FF_FireMag':
					case 'FF_FireBeam':
					case 'FF_FireConvA':
					case 'FF_FireMagA':
					case 'FF_FireBeamA':
						Weapon.WeaponFireKillAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
						return;
					default:
						Weapon.WeaponFireAnimSequenceName = 'FF_FireMagA';
						Weapon.WeaponFireKillAnimSequenceName = 'FF_FireMagA';
						return;
				}
				return;
			}
			//	Vektor Rifle
			if (class'X2Ability_IRI_JetPacks'.default.VEKTOR_CATEGORIES.Find(Template.WeaponCat) != INDEX_NONE) 
			{
				//`LOG("Vektor Rifle animations assigned",, 'IRIJET');
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(Content.RequestGameArchetype("JetPacks.Anims.AS_JetShot_Vektor")));
				switch (Weapon.WeaponFireAnimSequenceName)
				{
					case 'FF_FireConv':
					case 'FF_FireMag':
					case 'FF_FireBeam':
					case 'FF_FireConvA':
					case 'FF_FireMagA':
					case 'FF_FireBeamA':
						Weapon.WeaponFireKillAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
						return;
					default:
						Weapon.WeaponFireAnimSequenceName = 'FF_FireConvA';
						Weapon.WeaponFireKillAnimSequenceName = 'FF_FireConvA';
						return;
				}
				return;
			}
		}
	}
}


//----------------------------------------------------------- 2023



// To avoid crashes associated with garbage collection failure when transitioning between Tactical and Strategy,
// this function must be bound to the ClassDefaultObject of your class. Having this function in a class that
// `extends X2DownloadableContentInfo` is the easiest way to ensure that.
static private function EHLDelegateReturn OverrideHasHeightAdvantage(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, out int bHasHeightAdvantage)
{
	local UnitValue UV;
    // Optionally modify bHasHeightAdvantage here.
    // `bHasHeightAdvantage` is `0` if the `Attacker` does not have height advantage over the `TargetUnit`,
    // and `1` if height advantage is present.

	// Check for Jet Pack user against an enemy.
	if (Attacker.GetUnitValue(class'X2Item_IRI_JetPacks'.default.JetPackEquippedValue, UV))
	{
		bHasHeightAdvantage = 1;
	} // Check for enemy against Jet Pack user so that the Jet Pack user doesn't get a Height Disadvantage penalty. 
	else if (TargetUnit.GetUnitValue(class'X2Item_IRI_JetPacks'.default.JetPackEquippedValue, UV))
	{
		bHasHeightAdvantage = 0;
	}

	//`LOG("Attacker:" @ Attacker.GetFullName() @ "TargetUnit:" @ TargetUnit.GetFullName() @ "Has height advantage:" @ bHasHeightAdvantage == 1,, 'JET_PACKS');

	// Return EHLDR_NoInterrupt or EHLDR_InterruptDelegates depending on
    // if you want to allow other delegates to run after yours
    // and potentially modify bHasHeightAdvantage further.

    return EHLDR_NoInterrupt;
}