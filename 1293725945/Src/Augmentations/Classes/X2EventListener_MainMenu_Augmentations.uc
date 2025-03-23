class X2EventListener_MainMenu_Augmentations extends X2EventListener;

var delegate<OnItemSelectedCallback> NextOnSelectionChanged;
delegate OnItemSelectedCallback(UIList _list, int itemIndex);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMainMenuListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateMainMenuListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AugmentationsOnArmoryMainMenuUpdate');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OnArmoryMainMenuUpdate', OnArmoryMainMenuUpdate, ELD_Immediate);
	`LOG("Register Event OnArmoryMainMenuUpdate",, 'Augmentations');

	return Template;
}


static function EventListenerReturn OnArmoryMainMenuUpdate(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local UIList List;
	local UIArmory_MainMenu MainMenu;
	local UIListItemString StatUIButton;
	local XComGameState_Unit UnitState;
	local UnitValue SeveredBodyPart;
	local bool bNeedsAttention;

	`LOG(GetFuncName(),, 'Augmentations');
	
	List = UIList(EventData);
	MainMenu = UIArmory_MainMenu(EventSource);	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(MainMenu.GetUnitRef().ObjectID));

	if (
		UnitState.IsSoldier() && 
		class'X2StrategyElement_AugmentationSlots'.default.CharacterTemplateBlacklist.Find(UnitState.GetMyTemplateName()) == INDEX_NONE &&
		class'X2StrategyElement_AugmentationSlots'.default.CharacterClassBlacklist.Find(UnitState.GetSoldierClassTemplateName()) == INDEX_NONE
	) {
		bNeedsAttention = UnitState.GetUnitValue('SeveredBodyPart', SeveredBodyPart);

		StatUIButton = MainMenu.Spawn(class'UIListItemString', List.ItemContainer).InitListItem(class'UIArmory_Augmentations'.default.m_strInventoryTitle);
		StatUIButton.MCName = 'ArmoryMainMenu_AugmentationsUIButton';
		StatUIButton.ButtonBG.OnClickedDelegate = OnAugmentations;
		StatUIButton.NeedsAttention(bNeedsAttention);

		//if(NextOnSelectionChanged == none)
		//{
		// 	NextOnSelectionChanged = List.OnSelectionChanged;
		//	List.OnSelectionChanged = OnSelectionChanged;
		//}
		List.MoveItemToBottom(FindDismissListItem(List));
	}
	else
	{
		List.RemoveChild(FindAugmentationListItem(List));
	}
	return ELR_NoInterrupt;
}


simulated function OnAugmentations(UIButton kButton)
{
	local UIArmory_MainMenu MainMenu;
	local XComHQPresentationLayer HQPres;
	local UIArmory_Augmentations AugmentationScreen;

	MainMenu = UIArmory_MainMenu(kButton.GetParent(class'UIArmory_MainMenu', true));

	HQPres = XComHQPresentationLayer(MainMenu.Movie.Pres);

	if( HQPres == none )
		return;

	if (`SCREENSTACK.IsNotInStack(class'UIArmory_Augmentations'))
	{
		AugmentationScreen = UIArmory_Augmentations(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_Augmentations', HQPres), HQPres.Get3DMovie()));
		AugmentationScreen.InitArmory(MainMenu.GetUnitRef());
		`LOG(GetFuncName() @ MainMenu.GetUnitRef().ObjectID,, 'Augmentations');
	}

	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

simulated static function UIListItemString FindDismissListItem(UIList List)
{
	return UIListItemString(List.GetChildByName('ArmoryMainMenu_DismissButton', false));
}

simulated static function UIListItemString FindAugmentationListItem(UIList List)
{
	return UIListItemString(List.GetChildByName('UIArmory_Augmentations', false));
}

simulated function OnSelectionChanged(UIList ContainerList, int ItemIndex)
{
	local UIArmory_MainMenu MainMenu;

	MainMenu = UIArmory_MainMenu(ContainerList.GetParent(class'UIArmory_MainMenu', true));

	if (ContainerList.GetItem(ItemIndex).MCName == 'ArmoryMainMenu_AugmentationsUIButton') 
	{
		MainMenu.MC.ChildSetString("descriptionText", "htmlText", class'UIUtilities_Text'.static.AddFontInfo("Enhance your soldier with cybernetic augmentations", true));
		return;
	}
	NextOnSelectionChanged(ContainerList, ItemIndex);
}

