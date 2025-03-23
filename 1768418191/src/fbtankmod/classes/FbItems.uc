class fbitems extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue barrage_BASEDAMAGEacv;
var config int barrage_ENVDAMAGEacv;

var config int barrage_SELECTION_RANGEacv;
var config int barrage_TARGETING_AREA_RADIUSacv;

var config WeaponDamageValue acvdmg;
var config WeaponDamageValue acvdmgplayer;
var config WeaponDamageValue acvdmgplayerfire;
var config WeaponDamageValue acvdmgturret;
var config WeaponDamageValue acvdmgturretplayer;
var config WeaponDamageValue acvdmgram;
var config WeaponDamageValue acvdmglaser;
var config WeaponDamageValue acvdmgsaturation;
var config WeaponDamageValue acvdmgspin;
var config WeaponDamageValue acvdmgheat;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateTemplate_tankram());
	Items.AddItem(CreateTemplate_acv_laser());
	Items.AddItem(CreateTemplate_acv_WPN4());
	Items.AddItem(CreateTemplate_acv_WPN3());
	Items.AddItem(CreateTemplate_acv_WPN2());
	Items.AddItem(CreateTemplate_acv_WPN());
	Items.AddItem(CreateTemplate_acvrocket());

	Items.AddItem(CreateTemplate_acv_laserplayer());
	Items.AddItem(CreateTemplate_acv_WPNplayer());
	Items.AddItem(CreateTemplate_acvrocketplayer());
	Items.AddItem(CreateTemplate_flamerplayer());
	
	Items.AddItem(CreateTemplate_misslebarrageitemacv());

	
	
	return Items;
}

static function X2DataTemplate CreateTemplate_tankram()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'tankram_WPN');

	Template.WeaponPanelImage = "_BeamCannon";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgram;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_BEAM_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;
	Template.iRange = 7;
	Template.iRadius = 7;

	Template.DamageTypeTemplateName = 'Heavy';
	Template.InfiniteAmmo = true;
	Template.InventorySlot = eInvSlot_QuinaryWeapon;

	Template.Abilities.AddItem('tankram1');

	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "WP_Sectopod_Turret.WP_Sectopod_WrathCannon";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2DataTemplate CreateTemplate_acv_laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_laser');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	



	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmglaser;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('Blasterrelaser');

	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turretlaser";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.SetAnimationNameForAbility('Blasterrelaser', 'FF_fireb');

	return Template;
}

static function X2DataTemplate CreateTemplate_acv_WPN4()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_WPN4');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	


	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgturret;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SenaryWeapon;
	

	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret5";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_acv_WPN3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_WPN3');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	


	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgturret;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	

	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret3";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_acv_WPN2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_WPN2');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	


	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgturret;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_SeptenaryWeapon;
	

	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret4";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_acv_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_WPN');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'riflefbtank';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	



	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgturret;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Blasterre');
	Template.Abilities.AddItem('SaturationFire');
	Template.Abilities.AddItem('BlasterDuringCannon');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret2";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2WeaponTemplate CreateTemplate_acvrocket()
{
	local X2WeaponTemplate Template;
	

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acvrocket');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'utilityxx';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";


	Template.iRange = 29;
	Template.iRadius = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RADIUS;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.acvdmg;
	Template.iClipSize = 8;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	

	
	Template.InventorySlot = eInvSlot_Secondaryweapon;
	Template.StowedLocation = eSlot_None;
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret";
	Template.AltGameArchetype = "fbnewgarbage.WP_Sectopod_Turret";
	Template.ArmorTechCatForAltArchetype = 'powered';
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.Abilities.AddItem('RocketLauncheracv');

	Template.SetAnimationNameForAbility('RocketLauncheracv', 'FF_firec');

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
		

	
	return Template;
}




static function X2DataTemplate CreateTemplate_acv_laserplayer()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_laserplayer');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	



	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmglaser;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('Blasterrelaserplayer');

	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turretlaser";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.SetAnimationNameForAbility('Blasterrelaser', 'FF_fireb');

	return Template;
}


static function X2DataTemplate CreateTemplate_acv_WPNplayer()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acv_WPNplayer');
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'riflefbtank2';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	



	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.acvdmgturretplayer;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Blasterreplayer');
	Template.Abilities.AddItem('BlasterDuringCannon');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turret2";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2WeaponTemplate CreateTemplate_acvrocketplayer()
{
	local X2WeaponTemplate Template;
	

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'acvrocketplayer');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'utilityxxxs';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";


	Template.iRange = 29;
	Template.iRadius = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RADIUS;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.acvdmgplayer;
	Template.iClipSize = 2;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	

	
	Template.InventorySlot = eInvSlot_Secondaryweapon;
	Template.StowedLocation = eSlot_None;
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turretnewbeam";
	Template.AltGameArchetype = "fbnewgarbage.WP_Sectopod_Turretnewbeam";
	Template.ArmorTechCatForAltArchetype = 'powered';
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.Abilities.AddItem('RocketLauncheracvplayer');

	Template.SetAnimationNameForAbility('RocketLauncheracv', 'FF_fired');

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
		

	
	return Template;
}

static function X2WeaponTemplate CreateTemplate_flamerplayer()
{
	local X2WeaponTemplate Template;
	

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'flamerplayer');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'utilityxxxs';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";


	Template.iRange = 29;
	Template.iRadius = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RADIUS;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.acvdmgplayerfire;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_QuinaryWeapon;
	Template.StowedLocation = eSlot_None;
	Template.GameArchetype = "fbnewgarbage.WP_Sectopod_Turretnewbeam2";
	Template.AltGameArchetype = "fbnewgarbage.WP_Sectopod_Turretnewbeam2";
	Template.ArmorTechCatForAltArchetype = 'powered';
	Template.DamageTypeTemplateName = 'fire';

	//Template.Abilities.AddItem('RocketLauncheracvplayer2');

	Template.SetAnimationNameForAbility('RocketLauncheracv2', 'FF_fireflame');

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
		

	
	return Template;
}

static function X2DataTemplate CreateTemplate_misslebarrageitemacv()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'shivmissitemacv');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'utilityxxxs';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Strategyimages.ScienceIcons.IC_healshiv";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.barrage_BASEDAMAGEacv;
	Template.iClipSize = 0;
	Template.iSoundRange = 0;
	Template.iEnvironmentDamage = default.barrage_ENVDAMAGEacv;
	Template.iIdealRange = 0;
	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'BlazingPinions';

	Template.InventorySlot = eInvSlot_HeavyWeapon;

	Template.Abilities.AddItem('barrageStrikeacv');
	Template.Abilities.AddItem('barrageStrike2acv');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Archon_Blazing_Pinions.WP_Blazing_Pinions_CV";
	
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 45;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.barrage_SELECTION_RANGEacv);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.barrage_TARGETING_AREA_RADIUSacv);



	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}