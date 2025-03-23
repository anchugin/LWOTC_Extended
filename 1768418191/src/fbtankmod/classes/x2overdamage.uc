class X2overdamage extends X2Effect_SpawnUnit;

var localized string ParthenogenicPoisonText;

//var name ParthenogenicPoisonType;



var private name DiedWithParthenogenicPoisonTriggerName;



simulated function SetPoisonDamageDamage()
{
	local X2Effect_ApplyWeaponDamage PoisonDamage;

	PoisonDamage = GetPoisonDamage();
	PoisonDamage.EffectDamageValue = class'fbitems'.default.acvdmgheat;
}

simulated function X2Effect_ApplyWeaponDamage GetPoisonDamage()
{
	return X2Effect_ApplyWeaponDamage(ApplyOnTick[0]);
}





defaultproperties
{
	EffectName="ParthenogenicPoisonEffect"
	bClearTileBlockedByTargetUnitFlag=true
	bCopyTargetAppearance=true

//	ParthenogenicPoisonType="Projectile_Conventional"


	Begin Object Class=X2Effect_ApplyWeaponDamage Name=PoisonDamage
		bAllowFreeKill=false
		bIgnoreArmor=true
		DamageTypes.Add("Projectile_Conventional")
	End Object

	ApplyOnTick.Add(PoisonDamage)

	DamageTypes.Add("Projectile_Conventional");
}