class abilitiesfbacv extends X2Ability
dependson (XComGameStateContext_Ability) config(GameCore);

var name Stage1PsiBombEffectName666;
var name PsiBombTriggerName666;

var WeaponDamageValue tankramdamage2;
var WeaponDamageValue tankoverdamage;

var WeaponDamageValue tankfiredmg1;
var WeaponDamageValue tankfiredmg2;
var WeaponDamageValue tankfiredmg3;
var WeaponDamageValue tankfiredmg4;


var name HighLowValueNametankheat;
var name HighLowValueNametankheat2;

/// 4th
var name HighLowValueNametankheat3;

/// shields
var name HighLowValueNametankheat4;

const SECTOPOD_LOW_VALUE0=0;
const SECTOPOD_LOW_VALUE1=1;
const SECTOPOD_LOW_VALUE2=2;
const SECTOPOD_LOW_VALUE3=3;
const SECTOPOD_LOW_VALUE4=4;
const SECTOPOD_LOW_VALUE5=5;

/// yup, i copied my own shiv code cuz im lazy.

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;


	Templates.AddItem(avengercleanup());
	Templates.AddItem(CreateBlasterShotAbilityrelaser());
	Templates.AddItem(CreateBlasterShotAbilityref());
	Templates.AddItem(RocketLauncherAbilityacv());
	Templates.AddItem(CreateInitialStateAbilityfbacvInitialState());
	Templates.AddItem(acvevac2());
	Templates.AddItem(acvevac());
	Templates.AddItem(FB_Telepshivtank());
	
	Templates.AddItem(CreateBlasterShotAbilityrefplayer());
	Templates.AddItem(CreateBlasterShotAbilityrelaserplayer());
	Templates.AddItem(RocketLauncherAbilityacvplayer());


	Templates.AddItem(tankunblocker());

	Templates.AddItem(Addtankvent1to0());
	Templates.AddItem(Addtankvent2to1());
	Templates.AddItem(Addtankvent3to2());
	Templates.AddItem(Addtankvent4to3());

	Templates.AddItem(Addtankvent5to4());

	
	Templates.AddItem(tankoverheat1());
	Templates.AddItem(tankoverheat2());
	Templates.AddItem(tankoverheat3());
	Templates.AddItem(tankoverheat4());
	Templates.AddItem(tankoverheat5());

	Templates.AddItem(tankoverheat1x2());
	Templates.AddItem(tankoverheat2x2());
	Templates.AddItem(tankoverheat3x2());
	Templates.AddItem(tankoverheat4x2());
	Templates.AddItem(tankoverheat5x2());

	Templates.AddItem(tankoverheat1x3());
	Templates.AddItem(tankoverheat2x3());
	Templates.AddItem(tankoverheat3x3());

	Templates.AddItem(Addtankventshutdown());
	Templates.AddItem(Addtankventshutdown2());

	Templates.AddItem(SaturationFiretank());
	Templates.AddItem(RunAndGunAbilitytank('RunAndGuntank'));
	Templates.AddItem(Addtankcoolantflush());

	Templates.AddItem(Addoverrideshutdown());
	Templates.AddItem(Addoverrideshutdown2());

	Templates.AddItem(Createoverrideon());
	Templates.AddItem(Createoverrideoff());

	Templates.AddItem(CreateInitialStateheatupgrade());
	
	Templates.AddItem(tankDemolition());
	Templates.AddItem(tankram1());

	Templates.AddItem(laserburnup('laserburnup',"img:///UILibrary_PerkIcons.UIPerk_torch"));
	Templates.AddItem(spikedram('spikedram',"img:///UILibrary_PerkIcons.UIPerk_ambush"));

	Templates.AddItem(Addarmorconstructor());
	Templates.AddItem(Createtankspinning());
	Templates.AddItem(Addtankshield1());

	Templates.AddItem(Createoverrideonshield());
	Templates.AddItem(Createoverrideoffshield());
	
	Templates.AddItem(RocketLauncherAbilityacvplayer2());
	Templates.AddItem(RocketLauncherAbilityacvplayer2a());
	Templates.AddItem(RocketLauncherAbilityacvplayer2b());
	Templates.AddItem(RocketLauncherAbilityacvplayer2c());
	Templates.AddItem(RocketLauncherAbilityacvplayer2d());

	Templates.AddItem(misslebarrageacv());
	Templates.AddItem(misslebarrage2acv());

	Templates.AddItem(CreateFrenzyDamageListenerAbilityshivacv());
	Templates.AddItem(CreateFrenzyTriggerAbilityshivacv());

	return Templates;
}




static function X2AbilityTemplate CreateFrenzyDamageListenerAbilityshivacv()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_RunBehaviorTree FrenzyBehaviorEffect;
	local array<name> SkipExclusions;
	local X2AbilityCooldown				Cooldown;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'shivdamagecontrolacv');
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_closecyberdisc";
	Template.Hostility = eHostility_Neutral;

	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = 1;
	//Template.AbilityCooldown = Cooldown;

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeUnrevealedAI = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.bDontDisplayInAbilitySummary = true;

	//Template.AdditionalAbilities.AddItem('FrenzyInfo');
	Template.AdditionalAbilities.AddItem('FrenzyTriggershivacv');

	// Frenzy may trigger if the unit is burning
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// This ability fires when the unit takes damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);



	// The shooter must not have Frenzy activated
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Effect_Frenzy'.default.EffectName, 'AA_UnitIsFrenzied');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilityTargetStyle = default.SelfTarget;

	FrenzyBehaviorEffect = new class'X2Effect_RunBehaviorTree';
	FrenzyBehaviorEffect.BehaviorTreeName = 'TryFrenzyTriggershivacv';
	Template.AddTargetEffect(FrenzyBehaviorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}



static function X2AbilityTemplate CreateFrenzyTriggerAbilityshivacv()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_PersistentStatChange FrenzyEffect;
	local array<name> SkipExclusions;
	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FrenzyTriggershivacv');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_closecyberdisc";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Defensive;

	Template.bDontDisplayInAbilitySummary = true;

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeUnrevealedAI = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	

	// Frenzy may trigger if the unit is burning
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// The shooter must not have Frenzy activated
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Effect_Frenzy'.default.EffectName, 'AA_UnitIsFrenzied');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	FrenzyEffect = new class'X2Effect_PersistentStatChange';
	FrenzyEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	FrenzyEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true);
	FrenzyEffect.AddPersistentStatChange(eStat_ArmorMitigation, 1);
	FrenzyEffect.DuplicateResponse = eDupe_Ignore;
	FrenzyEffect.EffectHierarchyValue = class'X2StatusEffects'.default.FRENZY_HIERARCHY_VALUE;
	Template.AddTargetEffect(FrenzyEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bSkipFireAction = true;
	Template.BuildVisualizationFn = Frenzy_BuildVisualization;
	Template.CinescriptCameraType = "Archon_Frenzy";

	return Template;
}

simulated function Frenzy_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local int EffectIndex;
	local X2Action_PlayAnimation PlayAnimation;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if( Context.IsResultContextHit() )
	{
		InteractingUnitRef = Context.InputContext.SourceObject;

		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

		//****************************************************************************************
		//Configure the visualization track for the target
		//****************************************************************************************
		InteractingUnitRef = Context.InputContext.PrimaryTarget;
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		//PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	//	PlayAnimation.Params.AnimName = 'HL_damage';
	//	PlayAnimation.bFinishAnimationWait = false;

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
		}

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_good);

				//****************************************************************************************
	}
}



static function X2AbilityTemplate misslebarrageacv()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2AbilityMultiTarget_BlazingPinions BlazingPinionsMultiTarget;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_DelayedAbilityActivation BlazingPinionsStage1DelayEffect;
	local X2Effect_Persistent BlazingPinionsStage1Effect;
	local X2Condition_UnitValue				IsHigh;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'barrageStrikeacv');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rocketlauncher";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bShowActivation = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.TwoTurnAttackAbility = 'CallSatStrike2';
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	//IsHigh = new class'X2Condition_UnitValue';
	//IsHigh.AddCheckValue(default.HighLowValueNamemissles, SECTOPOD_HIGH_VALUEmissles, eCheck_Exact);
	//Template.AbilityShooterConditions.AddItem(IsHigh);
	

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//Charges = new class 'X2AbilityCharges';
	//Charges.InitialCharges = 2;
	//Template.AbilityCharges = Charges;

	//ChargeCost = new class'X2AbilityCost_Charges';
	//ChargeCost.NumCharges = 1;
	//Template.AbilityCosts.AddItem(ChargeCost);

	

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
 
	Template.TargetingMethod = class'X2TargetingMethod_BlazingPinions';

	// The target locations are enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeCivilian = true;
	UnitProperty.ExcludeDead = true;
	UnitProperty.FailOnNonUnits = true;
	UnitProperty.IsOutdoors = true;
	UnitProperty.HasClearanceToMaxZ = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	BlazingPinionsMultiTarget = new class'X2AbilityMultiTarget_BlazingPinions';
	BlazingPinionsMultiTarget.fTargetRadius = 10;
	BlazingPinionsMultiTarget.NumTargetsRequired = 6;
	Template.AbilityMultiTargetStyle = BlazingPinionsMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 60;
	Template.AbilityTargetStyle = CursorTarget;

	//Delayed Effect to cause the second Blazing Pinions stage to occur
	BlazingPinionsStage1DelayEffect = new class 'X2Effect_DelayedAbilityActivation';
	BlazingPinionsStage1DelayEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	BlazingPinionsStage1DelayEffect.EffectName = 'BlazingPinionsStage1Delay';
	BlazingPinionsStage1DelayEffect.TriggerEventName = 'BlazingPinionsStage2Trigger';
	BlazingPinionsStage1DelayEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(BlazingPinionsStage1DelayEffect);

	// An effect to attach Perk FX to
	BlazingPinionsStage1Effect = new class'X2Effect_Persistent';
	BlazingPinionsStage1Effect.BuildPersistentEffect(1, true, false, true);
	BlazingPinionsStage1Effect.EffectName = 'BlazingPinionsStage1Effect';
	Template.AddShooterEffect(BlazingPinionsStage1Effect);

	Template.ActivationSpeech = 'Flamethrower';
	Template.bCrossClassEligible = false;

	//  The target FX goes in target array as there will be no single target hit and no side effects of this touching a unit
	Template.AddShooterEffect(new class'X2Effect_ApplyBlazingPinionsTargetToWorld');

	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SatStrikeStage1_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";
	Template.bFrameEvenWhenUnitIsHidden = true;
	
	return Template;
}

simulated function SatStrikeStage1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack, ActionMetadata;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local int i;
	local X2Action_MoveTurn MoveTurnAction;
	local X2Action_PlayAnimation PlayAnimation;
	local X2Action_CameraFrameAbility FrameAction;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);


	FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(ActionMetadata, abilityContext));
	FrameAction.AbilitiesToFrame.AddItem(abilityContext);
	
	


	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Bad);


	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];

	// Fly up actions
	//class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, ActionMetadata);

	// Play the animation to get him to his looping idle
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PlayAnimation.Params.AnimName = 'hl_quick';
	PlayAnimation.bFinishAnimationWait = true;
	
	for( i = 0; i < AbilityContext.ResultContext.ShooterEffectResults.Effects.Length; ++i )
	{
		AbilityContext.ResultContext.ShooterEffectResults.Effects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 
																								  AbilityContext.ResultContext.ShooterEffectResults.ApplyResults[i]);
	}

}

static function X2AbilityTemplate misslebarrage2acv()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener DelayedEventListener;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2AbilityMultiTarget_Radius RadMultiTarget;
	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'barrageStrike2acv');
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rocketlauncher";

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	
	DelayedEventListener = new class'X2AbilityTrigger_EventListener';
	DelayedEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DelayedEventListener.ListenerData.EventID = 'BlazingPinionsStage2Trigger';
	DelayedEventListener.ListenerData.Filter = eFilter_Unit;
	DelayedEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_BlazingPinions;
	Template.AbilityTriggers.AddItem(DelayedEventListener);



	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('BlazingPinionsStage1Effect');
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_ApplyBlazingPinionsTargetToWorld'.default.EffectName);
	Template.AddShooterEffect(RemoveEffects);

	RadMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadMultiTarget.fTargetRadius = 6;

	Template.AbilityMultiTargetStyle = RadMultiTarget;

	// The MultiTarget Units are dealt this damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bApplyWorldEffectsForEachTargetLocation = true;
	Template.AddMultiTargetEffect(DamageEffect);



	Template.ModifyNewContextFn = SatStrikeStage2_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = BlazingPinionsStage2_BuildGameState;
	Template.BuildVisualizationFn = BlazingPinionsStage2_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}

simulated function SatStrikeStage2_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local TTile SelectedTile, LandingTile;
	local XComWorldData World;
	local vector TargetLocation, LandingLocation;
	local array<vector> FloorPoints;
	local int i;
	local X2AbilityMultiTargetStyle RadiusMultiTarget;
	local XComGameState_Ability AbilityState;
	local AvailableTarget MultiTargets;
	local PathingInputData InputData;

	History = `XCOMHISTORY;
	World = `XWORLD;

	AbilityContext = XComGameStateContext_Ability(Context);
	
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	// Find a valid landing location
	TargetLocation = World.GetPositionFromTileCoordinates(UnitState.TileLocation);

	LandingLocation = TargetLocation;
	LandingLocation.Z = World.GetFloorZForPosition(TargetLocation, true);
	LandingTile = World.GetTileCoordinatesFromPosition(LandingLocation);
	LandingTile = class'Helpers'.static.GetClosestValidTile(LandingTile);

	//if( !World.CanUnitsEnterTile(LandingTile) )
	//{
		// The selected tile is no longer valid. A new landing position
		// must be found. TODO: Decide what to do when FoundFloorPositions is false.
	//	World.GetFloorTilePositions(TargetLocation, World.WORLD_StepSize * 10, World.WORLD_StepSize, FloorPoints, true);

	//	i = 0;
	//	while( i < FloorPoints.Length )
	//	{
	//		LandingLocation = FloorPoints[i];
	//		LandingTile = World.GetTileCoordinatesFromPosition(LandingLocation);
	//		if( World.CanUnitsEnterTile(SelectedTile) )
	//		{
				// Found a valid landing location
	//			i = FloorPoints.Length;
	//		}

	//		++i;
	//	}
	//}

	//Attempting to build a path to our current location causes a problem, so avoid that
	//if(UnitState.TileLocation != LandingTile) 
	//{
		// Build the MovementData for the path
		// solve the path to get him to the end location
	//	class'X2PathSolver'.static.BuildPath(UnitState, UnitState.TileLocation, LandingTile, InputData.MovementTiles, false);

		// get the path points
	//	class'X2PathSolver'.static.GetPathPointsFromPath(UnitState, InputData.MovementTiles, InputData.MovementData);

		// string pull the path to smooth it out
	//	class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(UnitState.GetVisualizer()), InputData.MovementData);

		//Now add the path to the input context
	//	InputData.MovingUnitRef = UnitState.GetReference();
	//	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
	//}

	// Build the MultiTarget array based upon the impact points
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
	RadiusMultiTarget = AbilityState.GetMyTemplate().AbilityMultiTargetStyle;// new class'X2AbilityMultiTarget_Radius';

	AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
	for( i = 0; i < AbilityContext.InputContext.TargetLocations.Length; ++i )
	{
		RadiusMultiTarget.GetMultiTargetsForLocation(AbilityState, AbilityContext.InputContext.TargetLocations[i], MultiTargets);

		// Add the TargetLocations as ProjectileHitLocations
		AbilityContext.ResultContext.ProjectileHitLocations.AddItem(AbilityContext.InputContext.TargetLocations[i]);
	}

	AbilityContext.InputContext.MultiTargets = MultiTargets.AdditionalTargets;
}

simulated function XComGameState BlazingPinionsStage2_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;	
	local XComGameStateContext_Ability AbilityContext;
	local TTile LandingTile;
	local XComWorldData World;
	local X2EventManager EventManager;
	local vector LandingLocation;
	local int LastPathElement;

	World = `XWORLD;
	EventManager = `XEVENTMGR;

	//Build the new game state frame
	NewGameState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	
	//if(AbilityContext.InputContext.MovementPaths.Length > 0)
	//{
	//	LastPathElement = AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1;

		// Move the unit vertically, set the unit's new location
		// The last position in MovementData will be the end location
	//	`assert(LastPathElement > 0);
	//	LandingLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastPathElement /*- 1*/].Position;
	//	LandingTile = World.GetTileCoordinatesFromPosition(LandingLocation);
	//	UnitState.SetVisibilityLocation(LandingTile);

	//	AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	//	MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	//	EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
	//	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);
	//}

	//Return the game state we have created
	return NewGameState;
}

simulated function BlazingPinionsStage2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local X2Action_PersistentEffect	PersistentEffectAction;
	local int i, j;
	local X2VisualizerInterface TargetVisualizerInterface;

	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local XComGameState_InteractiveObject InteractiveObject;
	local X2Action_CameraFrameAbility FrameAction;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(ActionMetadata, abilityContext));
	FrameAction.AbilitiesToFrame.AddItem(abilityContext);
	


	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Bad);

	// Remove the override idle animation
	PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	PersistentEffectAction.IdleAnimName = '';

	// Play the firing action
	class'X2Action_BlazingPinionsStage2'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

	for( i = 0; i < AbilityContext.ResultContext.ShooterEffectResults.Effects.Length; ++i )
	{
		AbilityContext.ResultContext.ShooterEffectResults.Effects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 
																								  AbilityContext.ResultContext.ShooterEffectResults.ApplyResults[i]);
	}

	//if(AbilityContext.InputContext.MovementPaths.Length > 0)
	//{
	//	class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, ActionMetadata);
	//}
	

		//****************************************************************************************

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
		for( j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}

			}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

		for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}

			}
	//****************************************************************************************

	//Process any interactions with interactive objects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		// Add any doors that need to listen for notification
		if( InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim() && InteractiveObject.InteractionCount % 2 != 0 ) //Is this a closed door?
		{
			ActionMetadata = EmptyTrack;
			//Don't necessarily have a previous state, so just use the one we know about
			ActionMetadata.StateObject_OldState = InteractiveObject;
			ActionMetadata.StateObject_NewState = InteractiveObject;
			ActionMetadata.VisualizeActor = History.GetVisualizer(InteractiveObject.ObjectID);
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
			class'X2Action_BreakInteractActor'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

					}
	}
}








static function X2AbilityTemplate RocketLauncherAbilityacvplayer2()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect2;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect3;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect4;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect5;
	local X2Condition_UnitValue				IsHigh;
	

	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer2');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);
	
	Template.AdditionalAbilities.AddItem('RocketLauncheracvplayer2a');
	Template.AdditionalAbilities.AddItem('RocketLauncheracvplayer2b');
	Template.AdditionalAbilities.AddItem('RocketLauncheracvplayer2c');
	Template.AdditionalAbilities.AddItem('RocketLauncheracvplayer2d');

	
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 8 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);



	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}

static function X2AbilityTemplate RocketLauncherAbilityacvplayer2a()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect2;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect3;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect4;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect5;
	local X2Condition_UnitValue				IsHigh;
	

	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer2a');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE2, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);
	
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 8 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.EffectDamageValue = default.tankfiredmg1;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);



	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}

static function X2AbilityTemplate RocketLauncherAbilityacvplayer2b()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect2;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect3;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect4;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect5;
	local X2Condition_UnitValue				IsHigh;
	

	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer2b');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE3, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);
	
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 8 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.EffectDamageValue = default.tankfiredmg2;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);



	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}

static function X2AbilityTemplate RocketLauncherAbilityacvplayer2c()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect2;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect3;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect4;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect5;
	local X2Condition_UnitValue				IsHigh;
	

	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer2c');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);
	
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 8 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.EffectDamageValue = default.tankfiredmg3;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);



	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}

static function X2AbilityTemplate RocketLauncherAbilityacvplayer2d()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect2;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect3;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect4;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect5;
	local X2Condition_UnitValue				IsHigh;
	

	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer2d');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE5, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);
	
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 8 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;
	 
	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.EffectDamageValue = default.tankfiredmg4;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);



	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}


static function X2AbilityTemplate tankoverheat1x3()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat1x3');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;



	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat1x3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE3;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr1x3_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1x3_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat1x3'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat2x3()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat2x3');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat2x3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE4;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr2x33_BuildVisualization;

	return Template;
}

static simulated function kittytalkerz1ovr2x33_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat2x3'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat3x3()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat3x3');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE2, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat3x3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE5;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr3x2iiiu_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr3x2iiiu_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat3x2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}



static function X2AbilityTemplate Addarmorconstructor(name TemplateName = 'armorconstruct')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
 local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
 //  local X2Condition_UnitStatCheck         UnitStatCheckCondition;
   local X2Effect_PersistentStatChange		PersistentStatChangeEffect2;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);


	//UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	//UnitStatCheckCondition.AddCheckStat(eStat_ArmorMitigation, 5, eCheck_lessThan);
	//Template.AbilityShooterConditions.AddItem(UnitStatCheckCondition);

	 
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);





	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reinforcedarmor";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, -5);
	Template.AddTargetEffect(PersistentStatChangeEffect);


	PersistentStatChangeEffect2 = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect2.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect2.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect2.AddPersistentStatChange(eStat_ArmorMitigation, 5);
	Template.AddTargetEffect(PersistentStatChangeEffect2);


	Template.PostActivationEvents.AddItem('tankoverheat5');
	Template.PostActivationEvents.AddItem('tankoverheat4');
	Template.PostActivationEvents.AddItem('tankoverheat3');
	Template.PostActivationEvents.AddItem('tankoverheat2');
	Template.PostActivationEvents.AddItem('tankoverheat1');



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_quick';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}


static function X2AbilityTemplate tankram1()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2AbilityTarget_MovingMelee MeleeTarget;
	local X2Condition_Visibility VisibilityCondition;
	local X2AbilityCooldown				Cooldown;
	//local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
	local X2Effect_ApplyDirectionalWorldDamage WorldDamage;

	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone           ConeMultiTarget;
	local X2Effect_tankPush				KnockBackEffect2;
	local X2Effect_FaceMultiRoundTarget FaceTargetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankram1');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_kidnap";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.bCrossClassEligible = false;


	FaceTargetEffect = new class 'X2Effect_FaceMultiRoundTarget';
	FaceTargetEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	FaceTargetEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddShooterEffect(FaceTargetEffect);



	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	
	//Template.AdditionalAbilities.AddItem('tankram2');
	//Template.PostActivationEvents.AddItem('tankram2');

	KnockBackEffect2 = new class'X2Effect_tankPush';
	KnockBackEffect2.KnockbackDistance = 8;
	KnockBackEffect2.bKnockbackDestroysNonFragile = true;
	//KnockBackEffect2.bUseTargetLocation = true;
	Template.AddMultiTargetEffect(KnockBackEffect2);

	Template.AbilityToHitCalc = default.DeadEye;

	//MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	//Template.AbilityToHitCalc = MeleeHitCalc;

	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	PhysicalDamageEffect.EffectDamageValue = class'fbitems'.default.acvdmgram;
	PhysicalDamageEffect.EnvironmentalDamageAmount = 9999;

	Template.AddmultiTargetEffect(PhysicalDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 5 * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetStyle = CursorTarget;	

	//LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	//LineMultiTarget.TileWidthExtension = 1;
	//Template.AbilityMultiTargetStyle = LineMultiTarget;


	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = 5 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 5 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt( Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength) ) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;


	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//UnitPropertyCondition = new class'X2Condition_UnitProperty';
	//UnitPropertyCondition.ExcludeDead = true;
	//UnitPropertyCondition.ExcludeHostileToSource = false;
	//UnitPropertyCondition.FailOnNonUnits = true;
	//UnitPropertyCondition.Excludeturret = true;
	//UnitPropertyCondition.ExcludeFriendlyToSource = true; // Disable this to allow civilians to be attacked.
	//UnitPropertyCondition.ExcludeSquadmates = true;		   // Don't attack other AI units.
	//UnitPropertyCondition.RequireWithinRange = true;
	//UnitPropertyCondition.WithinRange = 544;
	//Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	
	
	//Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);




	Template.ConcealmentRule = eConceal_Always;


   // MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	//MeleeTarget.MovementRangeAdjustment = 0;
   // Template.AbilityTargetStyle = MeleeTarget;
	//Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	//Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = false;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 9999;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = true;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = true;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = 100;
	Template.AddMultiTargetEffect(WorldDamage);


	//KnockbackEffect = new class'X2Effect_Knockback';
	//KnockbackEffect.KnockbackDistance = 4;
	//KnockBackEffect.bKnockbackDestroysNonFragile = true;
	//KnockbackEffect.OnlyOnDeath = false;
	//Template.AddMultiTargetEffect(KnockBackEffect);

	
	
	

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	//Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = false;
	Template.CustomFireAnim = 'NO_ramming';
	Template.bSkipMoveStop = true;
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	

	
	return Template;
}



static function X2AbilityTemplate tankoverheat1()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;



	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat1');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat1';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE1;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;




	
	Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr1_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat1'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE2;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate tankoverheat3()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat3');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE2, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE3;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr3_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr3_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat3'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat4()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat4');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE3, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat4';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE4;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr4_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr4_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat4'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat5()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat5');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat5';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE5;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

		//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr5_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr5_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_quick'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}



static function X2AbilityTemplate tankoverheat1x2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat1x2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;



	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat1x2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE2;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr1x2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1x2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat1x2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate tankoverheat2x2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat2x2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat2x2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE3;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr2x2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr2x2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat2x2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate tankoverheat3x2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat3x2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE2, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat3x2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE4;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

	//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr3x2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr3x2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat3x2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}



static function X2AbilityTemplate tankoverheat4x2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;

	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat4x2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE3, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat4x2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE5;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

		//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr4x2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr4x2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_overheat4'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}




static function X2AbilityTemplate tankoverheat5x2()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoverheat5x2');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;
	Template.bDontDisplayInAbilitySummary = true;


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	///changed from 30000
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'tankoverheat5x2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 90000;
	Template.AbilityTriggers.AddItem(Trigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE5;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue);
	///
	Template.AssociatedPlayTiming = SPT_AfterSequential;
	Template.bTickPerActionEffects = true;

	Template.bCrossClassEligible = false;

		//Template.CustomFireAnim = 'HL_overheat1';
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	///
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = kittytalkerz1ovr5x2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr5x2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'hl_quick'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}




static function X2AbilityTemplate CreateBlasterShotAbilityrelaser( Name AbilityName='Blasterrelaser', bool bNoAmmoCost = false, bool bAllowBurning = true, bool bAllowDisoriented = true)
{


local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SkirmisherStrike');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Sectopod_LightningField";

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);

	Template.PostActivationEvents.AddItem('StandardShotActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AlternateFriendlyNameFn = StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;







	return Template;
}



static function X2AbilityTemplate CreateBlasterShotAbilityref( Name AbilityName='Blasterre', bool bNoAmmoCost = false, bool bAllowBurning = true, bool bAllowDisoriented = true)
{


local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventmec_minigun";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SkirmisherStrike');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Sectopod_LightningField";

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);

	Template.PostActivationEvents.AddItem('StandardShotActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AlternateFriendlyNameFn = StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;

	


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;




	return Template;
}

static function bool StandardShot_AlternateFriendlyName(out string AlternateDescription, XComGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	local XComGameState_Unit TargetUnit;

	// when targeting the lost, call the ability "Headshot" instead of "Fire Weapon"
	if( TargetRef.ObjectID > 0 )
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
		if( TargetUnit != None && TargetUnit.GetTeam() == eTeam_TheLost )
		{
			AlternateDescription = class'XLocalizedData'.default.HeadshotDescriptionText;
			return true;
		}
	}

	return false;
}


static function X2AbilityTemplate RocketLauncherAbilityacv()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityCooldown      Cooldown;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracv');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 30;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = 2800;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';



	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Sectopod_LightningField";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}

 
static function X2AbilityTemplate CreateInitialStateAbilityfbacvInitialState()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;
	local X2Effect_DamageImmunity DamageImmunity;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'fbacvInitialState');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AdditionalAbilities.AddItem('SectopodImmunities');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);



	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, true, true);
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.ImmuneTypes.AddItem('Unconscious');
	DamageImmunity.ImmuneTypes.AddItem('Panic');

	Template.AddTargetEffect(DamageImmunity);

	// Add 3rd action point per turn


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}






static function X2AbilityTemplate avengercleanup()
{
	local X2AbilityTemplate Template;
	local fucker12     SpawnMimicBeacon;
		local X2AbilityTrigger_EventListener EventListener;
	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'avengercleanup');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	EventListener.ListenerData.Priority = 46; //This ability must get triggered after the rest of the on-death listeners (namely, after mind-control effects get removed)
	Template.AbilityTriggers.AddItem(EventListener);


	// Build the immunities

	
  	SpawnMimicBeacon = new class'fucker12';
	SpawnMimicBeacon.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(SpawnMimicBeacon);
	Template.bShowActivation = false;
	
	


	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}











static function X2AbilityTemplate acvevac()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Effect_DelayedAbilityActivation DelayedDimensionalRiftEffect;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'acvevac');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.bDontDisplayInAbilitySummary = true;


	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evac";
	

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.Hostility = eHostility_Neutral;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AdditionalAbilities.AddItem('acvevac2');
	Template.TwoTurnAttackAbility = 'acvevac2';


	DelayedDimensionalRiftEffect = new class 'X2Effect_DelayedAbilityActivation';
	DelayedDimensionalRiftEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	DelayedDimensionalRiftEffect.EffectName = default.Stage1PsiBombEffectName666;
	DelayedDimensionalRiftEffect.TriggerEventName = default.PsiBombTriggerName666;
	DelayedDimensionalRiftEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(DelayedDimensionalRiftEffect);





	Template.ConcealmentRule = eConceal_Always;


	Template.bShowActivation = false;


	Template.bSkipFireAction = true;



	Template.CinescriptCameraType = "Soldier_Evac";



	Template.BuildNewGameStateFn = typicalAbility_BuildGameState;
	Template.BuildVisualizationFn = typicalAbility_BuildVisualization;

	return Template;
}






static function X2AbilityTemplate acvevac2()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityTrigger_EventListener DelayedEventListener;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'acvevac2');

	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bConsumeAllPoints = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);
	Template.bDontDisplayInAbilitySummary = true;


	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evac";
	

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_neverShow;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.Hostility = eHostility_Neutral;

	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	

	Template.ConcealmentRule = eConceal_Always;


	Template.bShowActivation = false;


	Template.bSkipFireAction = true;


	DelayedEventListener = new class'X2AbilityTrigger_EventListener';
	DelayedEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DelayedEventListener.ListenerData.EventID = default.PsiBombTriggerName666;
	DelayedEventListener.ListenerData.Filter = eFilter_Unit;
	DelayedEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(DelayedEventListener);






	Template.CinescriptCameraType = "Soldier_Evac";

	

	Template.BuildNewGameStateFn = EvacAbility_BuildGameStatex;
	Template.BuildVisualizationFn = EvacAbility_BuildVisualizationx;

	return Template;
}


simulated function XComGameState EvacAbility_BuildGameStatex( XComGameStateContext Context )
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit Source_OriginalState, Source_NewState;	
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	//Build the new game state and context
	NewGameState = History.CreateNewGameState(true, Context);	
	AbilityContext = XComGameStateContext_Ability(Context);	
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();	
	if (AbilityContext.InputContext.SourceObject.ObjectID != 0)
	{
		Source_OriginalState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		Source_NewState = XComGameState_Unit(NewGameState.CreateStateObject(Source_OriginalState.Class, Source_OriginalState.ObjectID));

		//Trigger this ability here so that any the EvacActivated event is triggered before UnitRemovedFromPlay
		`XEVENTMGR.TriggerEvent('EvacActivated', AbilityState, Source_NewState, NewGameState); 

		AbilityTemplate.ApplyCost(AbilityContext, AbilityState, Source_NewState, none, NewGameState);		
		Source_NewState.EvacuateUnit(NewGameState);
		NewGameState.AddStateObject(Source_NewState);
	}

	//Return the game state we have created
	return NewGameState;
}



simulated function EvacAbility_BuildVisualizationx(XComGameState VisualizeGameState)
{
	local XComGameStateHistory          History;
	local XComGameState_Unit            GameStateUnit;
	local VisualizationActionMetadata            EmptyTrack;
	local VisualizationActionMetadata            BuildTrack;
	local X2Action_PlaySoundAndFlyOver  SoundAndFlyover;
	local X2Action_SendInterTrackMessage MessageAction;
	local name                          nUnitTemplateName;
	local bool                          bIsVIP;
	local bool                          bNeedVIPVoiceover;
	local XComGameState_Unit            SoldierToPlayVoiceover;
	local array<XComGameState_Unit>     HumanPlayersUnits;
	local XComGameState_Effect          CarryEffect;




		//Decide on which VO cue to play, and which unit says it
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', GameStateUnit)
		{
			if (!GameStateUnit.bRemovedFromPlay)
				continue;

			nUnitTemplateName = GameStateUnit.GetMyTemplateName();
			switch(nUnitTemplateName)
			{
			case 'Soldier_VIP':
			case 'Scientist_VIP':
			case 'Engineer_VIP':
			case 'FriendlyVIPCivilian':
			case 'HostileVIPCivilian':
			case 'CommanderVIP':
			case 'Engineer':
			case 'Scientist':
				bIsVIP = true;
				break;
			default:
				bIsVIP = false;
			}

			if (bIsVIP)
			{
				bNeedVIPVoiceover = true;
			}
			else
			{
				if (SoldierToPlayVoiceover == None)
					SoldierToPlayVoiceover = GameStateUnit;
			}
		}

		//Build tracks for each evacuating unit
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', GameStateUnit)
		{
			if (!GameStateUnit.bRemovedFromPlay)
				continue;

			//Start their track
			BuildTrack = EmptyTrack;
			BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(GameStateUnit.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
			BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(GameStateUnit.ObjectID);
			BuildTrack.VisualizeActor = History.GetVisualizer(GameStateUnit.ObjectID);

			//Add this potential flyover (does this still exist in the game?)
			class'XComGameState_Unit'.static.SetUpBuildTrackForSoldierRelationship(BuildTrack, VisualizeGameState, GameStateUnit.ObjectID);

			//Play the VO if this is the soldier we picked for it
			if (SoldierToPlayVoiceover == GameStateUnit)
			{
				SoundAndFlyOver = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
				if (bNeedVIPVoiceover)
				{
					SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", 'VIPRescueComplete', eColor_Good);
					bNeedVIPVoiceover = false;
				}
				else
				{
					SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", 'EVAC', eColor_Good);
				}
			}

			//Note: AFFECTED BY effect state (being carried)
			CarryEffect = XComGameState_Unit(BuildTrack.StateObject_OldState).GetUnitAffectedByEffectState(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName);
			if (CarryEffect != None)
				class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()); //Being carried - just wait for message
			else
				class'X2Action_Evac'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()); //Not being carried - rope out
			
			//Note: APPLYING effect state (carrying another)
			CarryEffect = XComGameState_Unit(BuildTrack.StateObject_OldState).GetUnitApplyingEffectState(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName); 
			if (CarryEffect != None)
			{
				//Carrying someone - send a message to them when we're done roping out
				MessageAction = X2Action_SendInterTrackMessage(class'X2Action_SendInterTrackMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
				MessageAction.SendTrackMessageToRef = CarryEffect.ApplyEffectParameters.TargetStateObjectRef;
			}
			
			//Hide the pawn explicitly now - in case the vis block doesn't complete immediately to trigger an update
			class'X2Action_RemoveUnit'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext());

			//Add track to vis block
			
		}

		//If a VIP evacuated alone, we may need to pick an (arbitrary) other soldier on the squad to say the VO line about it.
		if (bNeedVIPVoiceover)
		{
			XGBattle_SP(`BATTLE).GetHumanPlayer().GetUnits(HumanPlayersUnits);
			foreach HumanPlayersUnits(GameStateUnit)
			{
				if (GameStateUnit.IsSoldier() && !GameStateUnit.IsDead() && !GameStateUnit.bRemovedFromPlay)
				{
					BuildTrack = EmptyTrack;
					BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(GameStateUnit.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
					BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
					BuildTrack.VisualizeActor = History.GetVisualizer(GameStateUnit.ObjectID);

					SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
					SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", 'VIPRescueComplete', eColor_Good);

					
					break;
				}
			}

		}
		
	


	//****************************************************************************************
}




static function X2AbilityTemplate FB_Telepshivtank()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Condition_UnitProperty UnitProperty2;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'teleporttank');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_leap";
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 6;
	Cooldown.NumGlobalTurns = 6;
	Template.AbilityCooldown = Cooldown;

	UnitProperty2 = new class'X2Condition_UnitProperty';
	UnitProperty2.ExcludeDead = true;
	//UnitProperty2.HasClearanceToMaxZ = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty2);

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	UnitProperty.ExcludeCosmetic = true;
	UnitProperty.FailOnNonUnits = true;
	//UnitProperty.IsOutdoors = true;
	//UnitProperty.HasClearanceToMaxZ = true; 
	UnitProperty.RequireWithinRange = true;
	UnitProperty.WithinRange = 2000;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);
	
	
	//Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';
	//Template.TargetingMethod = class'X2TargetingMethod_BlazingPinions';
	//Template.TargetingMethod = class'fbtelestuff';
	Template.TargetingMethod = class'X2TargetingMethod_Teleport';

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');

	Template.AbilityToHitCalc = default.DeadEye;

	//CursorTarget = new class'X2AbilityTarget_Cursor';
	//CursorTarget.FixedAbilityRange = 80.0f;
	//Template.AbilityTargetStyle = CursorTarget;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = 26; 
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 3.00; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	

	Template.ConcealmentRule = eConceal_Always;
	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//// Damage Effect
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);

	Template.bShowActivation = false;
	Template.ModifyNewContextFn = Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = Teleport_BuildGameState;
	Template.BuildVisualizationFn = Teleport_BuildVisualization;
	Template.CinescriptCameraType = "Cyberus_Teleport";

	return Template;
}


static simulated function Teleport_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local PathPoint NextPoint, EmptyPoint;
	local PathingInputData InputData;
	local XComWorldData World;
	local vector NewLocation;
	local TTile NewTileLocation;

	History = `XCOMHISTORY;
	World = `XWORLD;

	AbilityContext = XComGameStateContext_Ability(Context);
	`assert(AbilityContext.InputContext.TargetLocations.Length > 0);
	
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	// Build the MovementData for the path
	// First posiiton is the current location
	InputData.MovementTiles.AddItem(UnitState.TileLocation);

	NextPoint.Position = World.GetPositionFromTileCoordinates(UnitState.TileLocation);
	NextPoint.Traversal = eTraversal_Teleport;
	NextPoint.PathTileIndex = 0;
	InputData.MovementData.AddItem(NextPoint);

	// Second posiiton is the cursor position
	`assert(AbilityContext.InputContext.TargetLocations.Length == 1);

	NewLocation = AbilityContext.InputContext.TargetLocations[0];
	NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
	NewLocation = World.GetPositionFromTileCoordinates(NewTileLocation);

	NextPoint = EmptyPoint;
	NextPoint.Position = NewLocation;
	NextPoint.Traversal = eTraversal_Landing;
	NextPoint.PathTileIndex = 1;
	InputData.MovementData.AddItem(NextPoint);
	InputData.MovementTiles.AddItem(NewTileLocation);

    //Now add the path to the input context
	InputData.MovingUnitRef = UnitState.GetReference();
	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
}

static simulated function XComGameState Teleport_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local vector NewLocation;
	local TTile NewTileLocation;
	local XComWorldData World;
	local X2EventManager EventManager;
	local int LastElementIndex;

	World = `XWORLD;
	EventManager = `XEVENTMGR;

	//Build the new game state frame
	NewGameState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

	LastElementIndex = AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1;

	// Set the unit's new location
	// The last position in MovementData will be the end location
	`assert(LastElementIndex > 0);
	NewLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastElementIndex].Position;
	NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
	UnitState.SetVisibilityLocation(NewTileLocation);

	NewGameState.AddStateObject(UnitState);

	AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);

	EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

	//Return the game state we have created
	return NewGameState;
}

simulated function Teleport_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack, BuildTrack;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local int i, j;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local X2Action_MoveTurn MoveTurnAction;
	local X2VisualizerInterface TargetVisualizerInterface;
	
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good);

	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(BuildTrack, AbilityContext));
	MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];

	// move action
	class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, BuildTrack);

	
	
	//****************************************************************************************

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.VisualizeActor = none;
		BuildTrack.StateObject_NewState = WorldDataUpdate;
		BuildTrack.StateObject_OldState = WorldDataUpdate;

		for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, AbilityContext.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[i]));
		}

		
	}

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for( i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
		BuildTrack = EmptyTrack;
		BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, AbilityContext);
		for( j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(BuildTrack.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		}

		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		}
	}
}





static function X2AbilityTemplate CreateBlasterShotAbilityrefplayer( Name AbilityName='Blasterreplayer', bool bNoAmmoCost = false, bool bAllowBurning = true, bool bAllowDisoriented = true)
{


local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2AbilityCooldown      Cooldown;
	local X2Effect_FaceMultiRoundTarget FaceTargetEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);



	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 0;
	Template.AbilityCooldown = Cooldown;

	FaceTargetEffect = new class 'X2Effect_FaceMultiRoundTarget';
	FaceTargetEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	FaceTargetEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddShooterEffect(FaceTargetEffect);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventmec_minigun";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SkirmisherStrike');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Sectopod_LightningField";

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;



	//do not copy these to other abilities.. or youll duplicate them. not good.


	/// ok dont copy them.. copy whats under this 
	Template.PostActivationEvents.AddItem('tankoverheat5x2');
	Template.PostActivationEvents.AddItem('tankoverheat4x2');
	Template.PostActivationEvents.AddItem('tankoverheat3x2');
	Template.PostActivationEvents.AddItem('tankoverheat2x2');
	Template.PostActivationEvents.AddItem('tankoverheat1x2');

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);

	Template.PostActivationEvents.AddItem('StandardShotActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//Template.AlternateFriendlyNameFn = StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;




	return Template;
}



static function X2AbilityTemplate CreateBlasterShotAbilityrelaserplayer( Name AbilityName='Blasterrelaserplayer', bool bNoAmmoCost = false, bool bAllowBurning = true, bool bAllowDisoriented = true)
{


local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Condition_AbilityProperty				AbilityCondition;
	local X2Effect_Burning							BurningEffect;
	local X2Effect_FaceMultiRoundTarget FaceTargetEffect;


	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	FaceTargetEffect = new class 'X2Effect_FaceMultiRoundTarget';
	FaceTargetEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	FaceTargetEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddShooterEffect(FaceTargetEffect);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SkirmisherStrike');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Sectopod_LightningField";

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.PostActivationEvents.AddItem('tankoverheat5');
	Template.PostActivationEvents.AddItem('tankoverheat4');
	Template.PostActivationEvents.AddItem('tankoverheat3');
	Template.PostActivationEvents.AddItem('tankoverheat2');
	Template.PostActivationEvents.AddItem('tankoverheat1');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('laserburnup');
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(1,0);
	BurningEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BurningEffect);
	 

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);

	Template.PostActivationEvents.AddItem('StandardShotActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AlternateFriendlyNameFn = StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;







	return Template;
}


static function X2AbilityTemplate laserburnup(name TemplateName, string IconImage) {
	local X2AbilityTemplate						Template;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate RocketLauncherAbilityacvplayer()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Effect_FaceMultiRoundTarget FaceTargetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RocketLauncheracvplayer');

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.bDontDisplayInAbilitySummary = true;

	FaceTargetEffect = new class 'X2Effect_FaceMultiRoundTarget';
	FaceTargetEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	FaceTargetEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddShooterEffect(FaceTargetEffect);

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = class'X2Ability_HeavyWeapons'.default.SHREDDER_GUN_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_plasmablaster";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.PostActivationEvents.AddItem('tankoverheat5x2');
	Template.PostActivationEvents.AddItem('tankoverheat4x2');
	Template.PostActivationEvents.AddItem('tankoverheat3x2');
	Template.PostActivationEvents.AddItem('tankoverheat2x2');
	Template.PostActivationEvents.AddItem('tankoverheat1x2');


	Template.bShowActivation = true;




	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;
	

	return Template;	
}








static function X2AbilityTemplate tankunblocker()
{
	local X2AbilityTemplate Template;
	


	local X2AbilityCharges              Charges;
	//local X2AbilityTrigger_EventListener    trigger;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;
	local tankdisallowance autofirt;
	local X2Effect_UnblockPathing			CivilianUnblockPathingEffect;
	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankunblocker');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDontDisplayInAbilitySummary = true;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	
	//Trigger = new class'X2AbilityTrigger_EventListener';
	//Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	//Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	//Trigger.ListenerData.Filter = eFilter_Player;
	//Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	//Template.AbilityTriggers.AddItem(Trigger);
	
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);


	CivilianUnblockPathingEffect = new class'X2Effect_UnblockPathing';
	CivilianUnblockPathingEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddShooterEffect(CivilianUnblockPathingEffect);

	autofirt = new class'tankdisallowance';
	autofirt.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddShooterEffect(autofirt);


	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}




	


	


static function X2AbilityTemplate Addtankvent1to0(name TemplateName = 'tankvent1to0')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;


	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);



	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat1to0';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	Template.BuildVisualizationFn = kittytalkerz1ovr1vent1_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1vent1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'HL_overheat1to0'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate Addtankvent2to1(name TemplateName = 'tankvent2to1')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE2, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE1;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat2to1';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	Template.BuildVisualizationFn = kittytalkerz1ovr1vent2_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1vent2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'HL_overheat2to1'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate Addtankvent3to2(name TemplateName = 'tankvent3to2')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE3, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE2;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat3to2';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

		Template.BuildVisualizationFn = kittytalkerz1ovr1vent3_BuildVisualization;

	return Template;
}



static simulated function kittytalkerz1ovr1vent3_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'HL_overheat3to2'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate Addtankvent4to3(name TemplateName = 'tankvent4to3')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE3;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat3to2';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

		Template.BuildVisualizationFn = kittytalkerz1ovr1vent4_BuildVisualization;

	return Template;
}


static simulated function kittytalkerz1ovr1vent4_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'HL_overheat4to3'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}

static function X2AbilityTemplate Addtankvent5to4(name TemplateName = 'tankvent5to4')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE5, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE4;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat3to2';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

		Template.BuildVisualizationFn = kittytalkerz1ovr1vent5_BuildVisualization;

	return Template;
}


static simulated function kittytalkerz1ovr1vent5_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        BuildTrack;

	local X2Action_CameraFrameAbility FrameAction;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local UnitValue EverVigilantValue;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local string FlyOverText, FlyOverImage;
	local XGUnit UnitVisualizer;
	local X2Action_PlayAnimation PlayAnimationAction;


	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Only turn the camera on the overwatcher if it is visible to the local player.
	if( !`XENGINE.IsMultiPlayerGame() || class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectID, VisualizeGameState.HistoryIndex) )
	{
		FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(BuildTrack, Context));
		FrameAction.AbilitiesToFrame.AddItem(Context);
	}
	
		
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'HL_quick'; 
		PlayAnimationAction.bFinishAnimationWait = true;
	
	
	

	
	//****************************************************************************************
}


static function X2AbilityTemplate Addtankventshutdown2(name TemplateName = 'tankventshutdown2')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
    local X2Condition_UnitValue				IsHigh2;
	local X2Condition_UnitValue				IsHigh3;
   local X2Effect_Stunned				    StunnedEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE5, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHigh2 = new class'X2Condition_UnitValue';
	IsHigh2.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh2);

	IsHigh3 = new class'X2Condition_UnitValue';
	IsHigh3.AddCheckValue(default.HighLowValueNametankheat3, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh3);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	//Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnended';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_overheatshutdown';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}



static function X2AbilityTemplate Addtankventshutdown(name TemplateName = 'tankventshutdown')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
    local X2Condition_UnitValue				IsHigh2;
	local X2Condition_UnitValue				IsHigh3;
   local X2Effect_Stunned				    StunnedEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_GreaterThanOrEqual);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHigh2 = new class'X2Condition_UnitValue';
	IsHigh2.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh2);

	IsHigh3 = new class'X2Condition_UnitValue';
	IsHigh3.AddCheckValue(default.HighLowValueNametankheat3, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh3);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	//Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnended';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_overheatshutdown';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}


static function X2AbilityTemplate SaturationFiretank()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
	local X2Effect_ApplyDirectionalWorldDamage WorldDamage;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SaturationFiretank');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;
	 
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;

	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	PhysicalDamageEffect.EffectDamageValue = class'fbitems'.default.acvdmgsaturation;
	
	Template.AddMultiTargetEffect(PhysicalDamageEffect);
	Template.bOverrideAim = true;

	Template.PostActivationEvents.AddItem('tankoverheat5x2');
	Template.PostActivationEvents.AddItem('tankoverheat4x2');
	Template.PostActivationEvents.AddItem('tankoverheat3x2');
	Template.PostActivationEvents.AddItem('tankoverheat2x2');
	Template.PostActivationEvents.AddItem('tankoverheat1x2');

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 20;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = true;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = true;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = class'X2Ability_GrenadierAbilitySet'.default.SATURATION_DESTRUCTION_CHANCE;
	Template.AddMultiTargetEffect(WorldDamage);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = class'X2Ability_GrenadierAbilitySet'.default.SATURATION_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 15 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = 99; //  large number to handle weapon range - targets will get filtered according to cone constraints
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.ActionFireClass = class'X2Action_Fire_SaturationFire';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SaturationFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bCrossClassEligible = false;
//END AUTOGENERATED CODE: Template Overrides 'SaturationFire'

	return Template;	
}

static function X2Effect_ApplyWeaponDamage ShredderDamageEffect()
{
	local X2Effect_ApplyWeaponDamage    DamageEffect;

	DamageEffect = new class'X2Effect_Shredder';
	
	return DamageEffect;
}

static function X2AbilityTemplate RunAndGunAbilitytank(Name AbilityName)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_GrantActionPoints    ActionPointEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_runandgun";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	SuperKillRestrictions(Template, 'RunAndGun_SuperKillCheck');
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.PostActivationEvents.AddItem('tankoverheat5');
	Template.PostActivationEvents.AddItem('tankoverheat4');
	Template.PostActivationEvents.AddItem('tankoverheat3');
	Template.PostActivationEvents.AddItem('tankoverheat2');
	Template.PostActivationEvents.AddItem('tankoverheat1');

	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;

	return Template;
}

static function SuperKillRestrictions(X2AbilityTemplate Template, name ThisSuperKill)
{
	local X2Condition_UnitValue ValueCondition;
	local X2Effect_SetUnitValue ValueEffect;

	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('RunAndGun_SuperKillCheck', 0, eCheck_Exact,,,'AA_RunAndGunUsed');
	ValueCondition.AddCheckValue('Reaper_SuperKillCheck', 0, eCheck_Exact,,,'AA_ReaperUsed');
	ValueCondition.AddCheckValue('Serial_SuperKillCheck', 0, eCheck_Exact,,,'AA_SerialUsed');
	Template.AbilityShooterConditions.AddItem(ValueCondition);

	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = ThisSuperKill;
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddShooterEffect(ValueEffect);
}

static function X2AbilityTemplate Addtankcoolantflush(name TemplateName = 'tankcoolantflush')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
   local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
	local X2AbilityCost_Charges                 ChargeCost;
	 local X2AbilityCharges              Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 2;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	//IsHigh = new class'X2Condition_UnitValue';
	//IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_Exact);
	//Template.AbilityShooterConditions.AddItem(IsHigh);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);




	SetLowValue4 = new class'X2Effect_SetUnitValue';
	SetLowValue4.UnitName = default.HighLowValueNametankheat;
	SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue4.CleanupType = eCleanup_BeginTactical;
	Template.AddshooterEffect(SetLowValue4);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_alwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_coolantflush';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}




static function X2AbilityTemplate Addoverrideshutdown2(name TemplateName = 'tankoverideshutdown2')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
  // local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
    local X2Condition_UnitValue				IsHigh2;
	local X2Condition_UnitValue				IsHigh3;
  // local X2Effect_Stunned				    StunnedEffect;
  local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
  local X2overdamage ParthenogenicPoisonEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE5, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHigh2 = new class'X2Condition_UnitValue';
	IsHigh2.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh2);

	IsHigh3 = new class'X2Condition_UnitValue';
	IsHigh3.AddCheckValue(default.HighLowValueNametankheat3, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh3);


	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	//Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnended';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);


	 
	//PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//PhysicalDamageEffect.EffectDamageValue = default.tankoverdamage;
	//PhysicalDamageEffect.EffectDamageValue.DamageType = 'Melee';
	//Template.AddTargetEffect(PhysicalDamageEffect);

	ParthenogenicPoisonEffect = new class'X2overdamage';
	ParthenogenicPoisonEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnbegin);
	//ParthenogenicPoisonEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ParthenogenicPoisonFriendlyName, default.ParthenogenicPoisonFriendlyDesc, Template.IconImage, true);
	ParthenogenicPoisonEffect.DuplicateResponse = eDupe_Ignore;
	ParthenogenicPoisonEffect.bRemoveWhenTargetDies = true;
	ParthenogenicPoisonEffect.SetPoisonDamageDamage();
	Template.AddTargetEffect(ParthenogenicPoisonEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	//StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false);
	//StunnedEffect.bRemoveWhenSourceDies = false;
	//Template.AddTargetEffect(StunnedEffect);

	//SetLowValue4 = new class'X2Effect_SetUnitValue';
	//SetLowValue4.UnitName = default.HighLowValueNametankheat;
	//SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	//SetLowValue4.CleanupType = eCleanup_BeginTactical;
	//Template.AddshooterEffect(SetLowValue4);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_shutover';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}


static function X2AbilityTemplate Addoverrideshutdown(name TemplateName = 'tankoverideshutdown')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
  // local X2Effect_SetUnitValue             SetLowValue4;
   local X2Condition_UnitValue				IsHigh;
    local X2Condition_UnitValue				IsHigh2;
	local X2Condition_UnitValue				IsHigh3;
  // local X2Effect_Stunned				    StunnedEffect;
  local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
  local X2overdamage ParthenogenicPoisonEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);


	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat, SECTOPOD_LOW_VALUE4, eCheck_GreaterThanOrEqual);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsHigh2 = new class'X2Condition_UnitValue';
	IsHigh2.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh2);

	IsHigh3 = new class'X2Condition_UnitValue';
	IsHigh3.AddCheckValue(default.HighLowValueNametankheat3, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh3);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	//Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnended';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AdditionalAbilities.AddItem('tankoveroff');
	Template.AdditionalAbilities.AddItem('tankoveron');
	Template.AdditionalAbilities.AddItem('tankoverideshutdown2');
	

	//PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//PhysicalDamageEffect.EffectDamageValue = default.tankoverdamage;
	//PhysicalDamageEffect.EffectDamageValue.DamageType = 'Melee';
	//Template.AddTargetEffect(PhysicalDamageEffect);

	ParthenogenicPoisonEffect = new class'X2overdamage';
	ParthenogenicPoisonEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnbegin);
	//ParthenogenicPoisonEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ParthenogenicPoisonFriendlyName, default.ParthenogenicPoisonFriendlyDesc, Template.IconImage, true);
	ParthenogenicPoisonEffect.DuplicateResponse = eDupe_Ignore;
	ParthenogenicPoisonEffect.bRemoveWhenTargetDies = true;
	ParthenogenicPoisonEffect.SetPoisonDamageDamage();
	Template.AddTargetEffect(ParthenogenicPoisonEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	//StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false);
	//StunnedEffect.bRemoveWhenSourceDies = false;
	//Template.AddTargetEffect(StunnedEffect);

	//SetLowValue4 = new class'X2Effect_SetUnitValue';
	//SetLowValue4.UnitName = default.HighLowValueNametankheat;
	//SetLowValue4.NewValueToSet = SECTOPOD_LOW_VALUE0;
	//SetLowValue4.CleanupType = eCleanup_BeginTactical;
	//Template.AddshooterEffect(SetLowValue4);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_shutover';

	Template.bShowActivation = true;
	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	return Template;	
}

static function X2AbilityTemplate Createoverrideon()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetHighValue;
	local X2Condition_UnitValue				IsLow;
	local X2Condition_UnitValue				IsNotImmobilized;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoveron');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch"; // TODO: This needs to be changed
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for Low check.
	IsLow = new class'X2Condition_UnitValue';
	IsLow.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsLow);

	//IsNotImmobilized = new class'X2Condition_UnitValue';
	//IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	//Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	

	
	// ------------
	// High effect.  
	// Set value to High.
	SetHighValue = new class'X2Effect_SetUnitValue';
	SetHighValue.UnitName = default.HighLowValueNametankheat2;
	SetHighValue.NewValueToSet = SECTOPOD_LOW_VALUE1;
	SetHighValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetHighValue);

	//Template.AddTargetEffect( CreateHeightChangeStatusEffect() );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	//Template.CinescriptCameraType = "Sectopod_HighStance";
	
	return Template;
}



static function X2AbilityTemplate Createoverrideoff()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	local X2Condition_UnitValue				IsNotImmobilized;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankoveroff');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for High check.
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat2, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	//IsNotImmobilized = new class'X2Condition_UnitValue';
	//IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	//Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// Low effects.  
	// Set value to Low.
	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat2;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);

	//RemoveEffect = new class'X2Effect_RemoveEffects';
	//RemoveEffect.EffectNamesToRemove.AddItem( default.HeightChangeEffectName );
	//Template.AddTargetEffect( RemoveEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}



static function X2AbilityTemplate CreateInitialStateheatupgrade()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_UnitPostBeginPlay Trigger;
	local X2Effect_SetUnitValue				SetLowValue;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'fbacvheatupgrade');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	 Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";


	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);


	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat3;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE1;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);


	// Add 3rd action point per turn


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate tankDemolition()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;
	local X2AbilityCooldown						Cooldown;
	local X2Condition_UnitProperty              TargetCondition;
	local X2AbilityToHitCalc_RollStat           RollStat;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankDemolition');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_demolition";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bLimitTargetIcons = true;

	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	RollStat = new class'X2AbilityToHitCalc_RollStat';
	RollStat.BaseChance = 20;
	Template.AbilityToHitCalc = RollStat;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive=false;
	TargetCondition.ExcludeDead=true;
	TargetCondition.ExcludeFriendlyToSource=true;
	TargetCondition.ExcludeHostileToSource=false;
	TargetCondition.TreatMindControlledSquadmateAsHostile=true;
	TargetCondition.ExcludeNoCover=true;
	TargetCondition.ExcludeNoCoverToSource=true;
	TargetCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 50;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = false;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	Template.AddTargetEffect(WorldDamage);

	Template.PostActivationEvents.AddItem('tankoverheat5');
	Template.PostActivationEvents.AddItem('tankoverheat4');
	Template.PostActivationEvents.AddItem('tankoverheat3');
	Template.PostActivationEvents.AddItem('tankoverheat2');
	Template.PostActivationEvents.AddItem('tankoverheat1');

	//  visually always appear as a miss so the target unit doesn't look like it's being damaged
	Template.bOverrideVisualResult = true;
	Template.OverrideVisualResult = eHit_Miss;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Demolition'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Demolition'

	return Template;
}



static function X2AbilityTemplate spikedram(name TemplateName, string IconImage) {
	local X2AbilityTemplate	Template;
	local X2Effect_SpikedRam Effect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_SpikedRam';
	Effect.BuildPersistentEffect(1, true, false, true);
	Effect.EffectName = 'SpikedRamEffect';
	Template.AbilityTargetEffects.AddItem(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate Createtankspinning()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
	local X2AbilityToHitCalc_StandardAim    StandardAim;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankspinning');
	//IconImage needs to be changed once there is an icon for this
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_deathblossom";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	//Template.AbilityToHitCalc = default.DeadEye;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;

	// Targets enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.bFriendlyFireWarning = false;
	
	//Triggered by player or AI
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//fire from self, with a radius amount
	Template.AbilityTargetStyle = default.SelfTarget;
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 11 * class'XComWorldData'.const.WORLD_StepSize * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	PhysicalDamageEffect.EnvironmentalDamageAmount = 30;
	PhysicalDamageEffect.EffectDamageValue = class'fbitems'.default.acvdmgspin;
	Template.AddmultiTargetEffect(PhysicalDamageEffect);

	//Cooldowns
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;

	Template.PostActivationEvents.AddItem('tankoverheat5x2');
	Template.PostActivationEvents.AddItem('tankoverheat4x2');
	Template.PostActivationEvents.AddItem('tankoverheat3x3');
	Template.PostActivationEvents.AddItem('tankoverheat2x3');
	Template.PostActivationEvents.AddItem('tankoverheat1x3');
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'tankspin3';
	Template.CinescriptCameraType = "Sectopod_LightningField";
//BEGIN AUTOGENERATED CODE: Template Overrides 'SectopodLightningField'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SectopodLightningField'
	
	return Template;
}



static function X2AbilityTemplate Addtankshield1(name TemplateName = 'tankshield1')
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener    trigger;
	local X2Effect_PersistentStatChange ShieldedEffect;
   local X2Condition_UnitValue				IsHigh;
   local X2Condition_UnitValue				IsHighshield;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.bDontDisplayInAbilitySummary = true;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bFreeCost = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);



	IsHighshield = new class'X2Condition_UnitValue';
	IsHighshield.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHighshield);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);


	 Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	//Template.AbilityTriggers.AddItem(InputTrigger);

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnbegun';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AdditionalAbilities.AddItem('tankshieldon');
	Template.AdditionalAbilities.AddItem('tankshieldoff');

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), 4);
	Template.AddShooterEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.CustomFireAnim = 'HL_overheat1to0';


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType = "GenericAccentCam";
	//Template.OverrideAbilityAvailabilityFn = Reload_OverrideAbilityAvailability;

	Template.BuildVisualizationFn = Shielded_BuildVisualization;

	return Template;
}



	
static function X2Effect_PersistentStatChange CreateShieldedEffect(string FriendlyName, string LongDescription, int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;

	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, FriendlyName, LongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;

	return ShieldedEffect;
}

simulated function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}

simulated function Shielded_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlayAnimation PlayAnimationAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimationAction.Params.AnimName = 'HL_quick';

	}


static function X2AbilityTemplate Createoverrideonshield()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetHighValue;
	local X2Condition_UnitValue				IsLow;
	local X2Condition_UnitValue				IsNotImmobilized;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankshieldon');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for Low check.
	IsLow = new class'X2Condition_UnitValue';
	IsLow.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE0, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsLow);

	//IsNotImmobilized = new class'X2Condition_UnitValue';
	//IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	//Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	

	
	// ------------
	// High effect.  
	// Set value to High.
	SetHighValue = new class'X2Effect_SetUnitValue';
	SetHighValue.UnitName = default.HighLowValueNametankheat4;
	SetHighValue.NewValueToSet = SECTOPOD_LOW_VALUE1;
	SetHighValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetHighValue);

	//Template.AddTargetEffect( CreateHeightChangeStatusEffect() );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	//Template.CinescriptCameraType = "Sectopod_HighStance";
	
	return Template;
}



static function X2AbilityTemplate Createoverrideoffshield()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue				SetLowValue;
	local X2Condition_UnitValue				IsHigh;
	local X2Condition_UnitValue				IsNotImmobilized;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'tankshieldoff');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for High check.
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueNametankheat4, SECTOPOD_LOW_VALUE1, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	//IsNotImmobilized = new class'X2Condition_UnitValue';
	//IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	//Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// Low effects.  
	// Set value to Low.
	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueNametankheat4;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE0;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);

	//RemoveEffect = new class'X2Effect_RemoveEffects';
	//RemoveEffect.EffectNamesToRemove.AddItem( default.HeightChangeEffectName );
	//Template.AddTargetEffect( RemoveEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}


DefaultProperties
{
Stage1PsiBombEffectName666="Stage1PsiBombEffect666"
PsiBombTriggerName666="PsiBombTrigger666"
	tankfiredmg1=(Damage=2, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 0, Shred=0, Tag = "", DamageType="fire")
		tankfiredmg2=(Damage=3, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 0, Shred=0, Tag = "", DamageType="fire")
			tankfiredmg3=(Damage=4, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 0, Shred=0, Tag = "", DamageType="fire")
				tankfiredmg4=(Damage=5, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 0, Shred=0, Tag = "", DamageType="fire")

	tankramdamage2=(Damage=6, Spread = 0, PlusOne = 0, Crit = 2, Pierce = 0, Shred=0, Tag = "", DamageType="Melee")
	tankoverdamage=(Damage=6, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 6, Shred=0, Tag = "", DamageType="Projectile_Conventional")
	HighLowValueNametankheat2 = "HighLowValueNametankheatscript2"
	HighLowValueNametankheat = "HighLowValueNametankheatscript"
	HighLowValueNametankheat3 = "HighLowValueNametankheatscript3"
	HighLowValueNametankheat4 = "HighLowValueNametankheatscript4"

}