Scriptname BasinActivator extends ObjectReference

import Game
import Utility

Message Property CleanYourselfMessage Auto
Message Property GroomedMessage Auto
Message Property CleanedMessage Auto
Spell Property CleanSpell Auto
Actor Property PlayerRef Auto
Idle Property RefreshedIdle Auto
String Property CleaningAnim Auto

STATIC Property XMarker Auto

ObjectReference BasinMarker

Bool IsGrooming = False
String RACE_MENU = "RaceSex Menu"

Event OnActivate(ObjectReference akActionRef)
	self.RegisterForMenu(RACE_MENU)
	If akActionRef == PlayerRef
		Int Button = CleanYourselfMessage.Show()

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
		self.UnregisterForMenu(menuName)
	EndIf
EndEvent

Function CleanYourself()
	; Clean
	AddMarker(PlayerRef)
	PlayerRef.SetPlayerControls(false)
	DisablePlayerControls(true, true, true, true)
	ForceThirdPerson()
	SetPlayerAIDriven(true)

	PlayerRef.PathToReference(BasinMarker, 1)
	PlayerRef.MoveTo(BasinMarker)

	CleanSpell.Cast(PlayerRef, PlayerRef)
	Debug.SendAnimationEvent(PlayerRef, CleaningAnim)
	Wait(4.0)
	ClearTempEffects()
	PlayerRef.PlayIdle(RefreshedIdle)

	If GetFormFromFile(0x01000824, "Dirt and Blood - Dynamic Visuals.esp")
		CleanYourselfDirtAndBlood()
	EndIf

	CleanedMessage.Show()

	PlayerRef.SetPlayerControls(true)
	SetPlayerAIDriven(false)
	DisablePlayerControls()
	Wait(0.1)
	EnablePlayerControls()
	PlayerRef.EnableAI()
	BasinMarker.Disable()
	BasinMarker.Delete()
EndFunction

Function AddMarker(ObjectReference akTarget)
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
		Spell Dirty_Spell_Clean = GetFormFromFile(0x0100080C, "Dirt and Blood - Dynamic Visuals.esp") as Spell

		PlayerRef.RemoveSpell(Dirty_Spell_Dirt1)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt2)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt3)
		PlayerRef.RemoveSpell(Dirty_Spell_Dirt4)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood1)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood2)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood3)
		PlayerRef.RemoveSpell(Dirty_Spell_Blood4)
		PlayerRef.AddSpell(Dirty_Spell_Clean, False)
EndFunction
