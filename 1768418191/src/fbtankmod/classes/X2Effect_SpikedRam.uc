class X2Effect_SpikedRam extends X2Effect_Persistent;

function int GetAttackingDamageModifier_CH(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if (AbilityState.GetMyTemplateName() != 'tankram1') {
		return 0;
	}

	switch (AppliedData.AbilityResultContext.HitResult) {
		case eHit_Crit: return 8;
		case eHit_Success: return 6;
		case eHit_Graze: return 3;
		default: return 0;
	}
}