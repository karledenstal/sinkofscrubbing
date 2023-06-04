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
STATIC Property XMarker Auto
Keyword Property HELMET_KEYWORD Auto

ObjectReference BasinMarker
Form EquippedHelmet

Bool IsGrooming = False
String RACE_MENU = "RaceSex Menu"
Int HEAD_SLOT = 1
int HAIR_SLOT = 2

Event OnActivate(ObjectReference akActionRef)
	self.RegisterForMenu(RACE_MENU)
	If akActionRef == PlayerRef
		Int Button = CleanYourselfMessage.Show()

		Form FullHelmet = PlayerRef.GetWornForm(HEAD_SLOT)
		Form Helmet = PlayerRef.GetWornForm(HAIR_SLOT)

		If FullHelmet && FullHelmet.HasKeyword(HELMET_KEYWORD)
			EquippedHelmet = FullHelmet
			PlayerRef.UnequipItem(FullHelmet)
		ElseIf Helmet && Helmet.HasKeyword(HELMET_KEYWORD)
			EquippedHelmet = Helmet
			PlayerRef.UnequipItem(Helmet)
		EndIf

		If Button == 0
			; Open racemenu
			IsGrooming = True
			ShowRaceMenu()
		ElseIf Button == 1
			; Clean
			CleanYourself()
		EndIf
	EndIf
EndEvent

Event OnMenuClose(String menuName)
	If menuName == RACE_MENU && IsGrooming
		IsGrooming = False
		GroomedMessage.Show()

		If EquippedHelmet
			PlayerRef.EquipItem(EquippedHelmet)
		EndIf
		self.UnregisterForMenu(menuName)
	EndIf
EndEvent

Function CleanYourself()
	; Clean
	AddMarker()
	ForceThirdPerson()
	PlayerRef.MoveTo(BasinMarker)
	Wait(0.1)
	Debug.SendAnimationEvent(PlayerRef, "IdleComeThisWay")
	CleanSound.Play(self)
	Wait(2.0)
	PlayerRef.PlayIdle(CleanedIdle)
	CleanSpell.Cast(PlayerRef, PlayerRef)
	ClearTempEffects()
	CleanedMessage.Show()

	If EquippedHelmet
		PlayerRef.EquipItem(EquippedHelmet)
	EndIf

	If GetFormFromFile(0x01000824, "Dirt and Blood - Dynamic Visuals.esp")
		CleanYourselfDirtAndBlood()
	EndIf
EndFunction

Function AddMarker()
	BasinMarker = self.PlaceAtMe(XMarker, 1)
	BasinMarker.MoveTo(self, -2, -23, 0, false)
EndFunction

Function CleanYourselfDirtAndBlood()
	PlayerRef.DispelSpell(CleanSpell)

	Spell Dirty_Spell_Dirt1 = GetFormFromFile(0x01000806, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt2 = GetFormFromFile(0x01000807, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt3 = GetFormFromFile(0x01000808, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Dirt4 = GetFormFromFile(0x01000838, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood1 = GetFormFromFile(0x01000809, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood2 = GetFormFromFile(0x0100080A, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood3 = GetFormFromFile(0x0100080B, "Dirt and Blood - Dynamic Visuals.esp") as Spell
	Spell Dirty_Spell_Blood4 = GetFormFromFile(0x01000839, "Dirt and Blood - Dynamic Visuals.esp") as Spell

	If PlayerRef.HasSpell(Dirty_Spell_Dirt4)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt4)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	ElseIf PlayerRef.HasSpell(Dirty_Spell_Dirt3)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt3)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	ElseIf PlayerRef.HasSpell(Dirty_Spell_Dirt2)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt2)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	ElseIf PlayerRef.HasSpell(Dirty_Spell_Blood4)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood4)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	ElseIf PlayerRef.HasSpell(Dirty_Spell_Blood3)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood3)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	ElseIf PlayerRef.HasSpell(Dirty_Spell_Blood2)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood2)
		PlayerRef.AddSpell(Dirty_Spell_Dirt1, False)
	EndIf
EndFunction