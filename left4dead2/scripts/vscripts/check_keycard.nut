::CheckKeycard <- function(activator) 
{
	//local PlayerWep = activator.GetActiveWeapon();
	local invTable = {};
	GetInvTable(activator, invTable);
	local PlayerWep = invTable["slot1"];
	
	if ( PlayerWep = "weapon_melee" && NetProps.GetPropString(PlayerWep , "m_strMapSetScriptName") == "keycard")
	{
		EmitSoundOnClient("Hint.Helpful" activator)	// You can remove this if you want
		EntFire("cage_door_button", "Unlock");
		EntFire("switch_glow_green", "ShowSprite");
	}
}

::LeaveWithKeycard <- function(activator) 
{
	//local PlayerWep = activator.GetActiveWeapon();
	local invTable = {};
	GetInvTable(activator, invTable);
	local PlayerWep = invTable["slot1"];
	
	if ( PlayerWep = "weapon_melee" && NetProps.GetPropString(PlayerWep , "m_strMapSetScriptName") == "keycard")
	{
		//EmitSoundOnClient("Survivor.PlaytestStart" activator)
		EntFire("cage_door_button", "Lock");
		EntFire("switch_glow_green", "HideSprite");
	}
}

::RemoveKeycard <- function(activator) 
{
	local invTable = {};
	GetInvTable(activator, invTable);
	local PlayerWep = invTable["slot1"];
	
	if ( PlayerWep = "weapon_melee" && NetProps.GetPropString(PlayerWep , "m_strMapSetScriptName") == "keycard")
	{
		invTable.slot1.Kill();
		activator.GiveItem("weapon_pistol")
		EntFire("switch_glow_green", "HideSprite");
	}
}