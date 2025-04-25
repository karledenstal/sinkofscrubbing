Scriptname BasinActivator extends ObjectReference

import Game
import Utility

Message Property CleanYourselfMessage Auto
Message Property GroomedMessage Auto
Message Property CleanedMessage Auto
Spell Property CleanSpell Auto
Actor Property PlayerRef Auto
Idle Property CleanedIdle Auto
Sound Property CleanSound Auto

ObjectReference BasinMarker
Armor StoredEquippedHelmet = None

Bool IsGrooming = False
String RACE_MENU = "RaceSex Menu"

Event OnActivate(ObjectReference akActionRef)
	bool isDnBInstalled = IsPluginInstalled("Dirt and Blood - Dynamic Visuals.esp")
	bool isKICInstalled = IsPluginInstalled("Keep It Clean.esp")

	self.RegisterForMenu(RACE_MENU)
	If akActionRef == PlayerRef
		Int Button = CleanYourselfMessage.Show()

		If Button != 2
			HandleHelmet()
		EndIf

		If Button == 0
			IsGrooming = True
			ShowRaceMenu()
		ElseIf Button == 1			
			If isDnBInstalled
				Debug.Notification("Dirt and Blood is installed")
				CleanYourselfDirtAndBlood()
			EndIf
		
			If isKICInstalled
				Debug.Notification("Keep it Clean is installed")
				CleanYourselfKeepItClean()
			EndIf

			If !isKICInstalled && !isDnBInstalled
				CleanYourself()
			EndIf

			ShowCleanedMessage(isKICInstalled)
			EquipHelmetBackOn()
		ElseIf Button == 2
			Return
		EndIf
	EndIf
EndEvent

Event OnMenuClose(String menuName)
	If menuName == RACE_MENU && IsGrooming
		IsGrooming = False
		GroomedMessage.Show()

		EquipHelmetBackOn()

		self.UnregisterForMenu(menuName)
	EndIf
EndEvent

Function HandleHelmet()
	Armor HeadGear = playerRef.GetEquippedArmorInSlot(30) ; check head slot
	Armor HoodGear = playerRef.GetEquippedArmorInSlot(31) ; check hair slot

	If HeadGear
		StoredEquippedHelmet = HeadGear
		PlayerRef.UnequipItem(HeadGear)
	ElseIf HoodGear
		StoredEquippedHelmet = HoodGear
		PlayerRef.UnequipItem(HoodGear)
	Else
		Debug.Notification("Nothing to unequip")
	EndIf
EndFunction

Function EquipHelmetBackOn()
	If StoredEquippedHelmet
		Wait(0.2)
		PlayerRef.EquipItem(StoredEquippedHelmet)
		StoredEquippedHelmet = None
	EndIf
EndFunction

Function ShowCleanedMessage(bool isKICInstalled)
	If isKICInstalled
		Message CleanedMsgKIC = GetFormFromFile(0x05113425, "Keep It Clean.esp") as Message
		CleanedMsgKIC.Show()
	Else
		CleanedMessage.Show()
	EndIf
EndFunction

Function CleanTriggered()
	Wait(0.1)
	Debug.SendAnimationEvent(PlayerRef, "IdleComeThisWay")
	CleanSound.Play(self)
	Wait(2.0)
	PlayerRef.PlayIdle(CleanedIdle)
EndFunction

Function CleanYourself()
	CleanTriggered()
	CleanSpell.Cast(PlayerRef, PlayerRef)
	ClearTempEffects()
EndFunction

Function CleanYourselfDirtAndBlood()
	PlayerRef.DispelSpell(CleanSpell)
	CleanTriggered()

	Spell Dirty_Spell_Dirt1 = GetFormFromFile(0x01000806, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt2 = GetFormFromFile(0x01000807, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt3 = GetFormFromFile(0x01000808, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt4 = GetFormFromFile(0x01000838, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood1 = GetFormFromFile(0x01000809, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood2 = GetFormFromFile(0x0100080A, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood3 = GetFormFromFile(0x0100080B, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood4 = GetFormFromFile(0x01000839, "Dirt and Blood - Dynamic Visuals.esp") as Spell

	; Just remove any spell possible
	PlayerRef.RemoveSpell(Dirty_Spell_Dirt2)
	PlayerRef.RemoveSpell(Dirty_Spell_Dirt3)
	PlayerRef.RemoveSpell(Dirty_Spell_Dirt4)
	PlayerRef.RemoveSpell(Dirty_Spell_Blood1)
	PlayerRef.RemoveSpell(Dirty_Spell_Blood2)
	PlayerRef.RemoveSpell(Dirty_Spell_Blood3)
	PlayerRef.RemoveSpell(Dirty_Spell_Blood4)

	; Add the "Slightly Dirty" effect to the player
	PlayerRef.AddSpell(Dirty_Spell_Dirt1)
EndFunction

Function CleanYourselfKeepItClean()
	PlayerRef.DispelSpell(CleanSpell)
	ClearEffectsKIC()

	Spell CleanSpell_KIC = GetFormFromFile(0x0511054D, "Keep It Clean.esp") as Spell
	GlobalVariable LastWashed = GetFormFromFile(0x050EA4EE, "Keep It Clean.esp") as GlobalVariable
	GlobalVariable DirtyTimeVar = GetFormFromFile(0x05253785, "Keep It Clean.esp") as GlobalVariable

	LastWashed.SetValue(GetCurrentGameTime())
	DirtyTimeVar.SetValue(0)

	PlayerRef.AddSpell(CleanSpell_KIC, False)
EndFunction

Function ClearEffectsKIC()
	FormList BathEffectsKIC = GetFormFromFile(0x05101B4D, "Keep It Clean.esp") as Formlist

	int CurrentEffect = 0

	While (CurrentEffect < BathEffectsKIC.GetSize())
		Spell SpellInList = BathEffectsKIC.GetAt(CurrentEffect) As Spell
		PlayerRef.RemoveSpell(SpellInList)
		CurrentEffect += 1
	EndWhile
EndFunction