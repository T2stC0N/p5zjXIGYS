
KeyCardFix <- {}

local function FixKeycardSpawns()
{
	local badkeycard = null;
	while ( badkeycard = Entities.FindByClassname(badkeycard, "weapon_melee_spawn") )
	{ 
		if( badkeycard.IsValid() )
		{ 
			if ( badkeycard.GetModelName() == "models/weapons/melee/w_keycard.mdl")
			{ 		
				local spawnTable =
				{
					origin = badkeycard.GetOrigin(),
					angles = badkeycard.GetAngles().ToKVString(),
					targetname = badkeycard.GetName(),
					count = NetProps.GetPropInt( badkeycard, "m_itemCount" ),
					spawnflags = NetProps.GetPropInt( badkeycard, "m_spawnflags" ),
					melee_weapon = "machete,fireaxe,frying_pan,katana,shovel,knife,tonfa,guitar,baseball_bat,cricket_bat,kopis,spear",
				}
				badkeycard.Kill()
				SpawnEntityFromTable("weapon_melee_spawn", spawnTable)
			}
		}
	}	
}
KeyCardFix.OnGameEvent_round_start_post_nav <- function ( params )
{
	FixKeycardSpawns();
}
__CollectGameEventCallbacks(KeyCardFix)