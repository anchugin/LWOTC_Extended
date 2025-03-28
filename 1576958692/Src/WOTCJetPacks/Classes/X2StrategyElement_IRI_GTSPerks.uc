class X2StrategyElement_IRI_GTSPerks extends X2StrategyElement config(JetPackSchematics);

var config bool ALLOW_DYNAMIC_DEPLOYMENT;
var config array<name> TECH_REQUIRED_FOR_DYNAMIC_DEPLOYMENT;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	if (default.ALLOW_DYNAMIC_DEPLOYMENT) {
		Templates.AddItem(Create_UnlockDynamicDeployment());
	}

	return Templates;
}

static function X2SoldierUnlockTemplate Create_UnlockDynamicDeployment()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'IRI_UnlockDynamicDeployment');

	Template.bAllClasses = true;
	Template.AbilityName = 'IRI_CallReinforcements';
	Template.strImage = "img:///JetPacks_UI.GTS_DynamicDeployment";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 3;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.RequiredTechs = default.TECH_REQUIRED_FOR_DYNAMIC_DEPLOYMENT;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


