::HulkTrain <- function(activator) 
{
	local HulkTrain = "models/infected/hulk_requiem_02.mdl";
	if(!IsModelPrecached(HulkTrain))
    PrecacheModel(HulkTrain)
    activator.SetModel(HulkTrain);
}

::CreatePickup <- function(Place) 
{
	local FancyKeyCard = "models/weapons/melee/w_keycard_pickup.mdl";
	if(!IsModelPrecached(FancyKeyCard))
	PrecacheModel(FancyKeyCard)
	
	// Create button
	local button = null;
	local button = SpawnEntityFromTable("func_button_timed",
	{
		targetname = "FancyKeyCard_Button",
		auto_disable = 1,
		use_string = "Nommers",
		use_time = 1,
		model = "models/weapons/melee/w_keycard_pickup.mdl"
		spawnflags = "256",
		rendermode = 10,
		disableshadows = "1",
		origin = Place.GetCenter(),
	});
	
	local pickup = null;
	local pickup = SpawnEntityFromTable("prop_dynamic",
	{
		targetname = "FancyKeyCard",
		model = "models/weapons/melee/w_keycard_pickup.mdl"
		spawnflags=268,
		disableshadows = "1",
		origin = button.GetOrigin(),
	});
	
	button.__KeyValueFromString("use_string","Taking Keycard");
	button.__KeyValueFromString("use_sub_string","I'm sure they won't mind");
	
	local keyValues =
	{
		targetname  = "explain_keycard_point",
		origin = Place.GetCenter(),
	}
	local keycard_hint_point = SpawnEntityFromTable( "info_target_instructor_hint", keyValues );
	local keyValues =
	{
		hint_name  = "explain_keycard",
		hint_target = keycard_hint_point.GetName(),
		hint_static = "0",
		hint_nooffscreen = "0",
		hint_caption = "Pick up the Keycard!",
		hint_instance_type = "2",
		hint_icon_onscreen = "icon_tip",
		hint_color = "255 255 255",
		hint_timeout = "7",
		hint_range = "350.0",
		hint_display_limit = "5",
		hint_auto_start = "1",
		hint_forcecaption = "1",
		hint_allow_nodraw_target = "1",
		targetname = "Keycard_hint"
		origin = Place.GetCenter(),
	}
	local keycard_hint = SpawnEntityFromTable( "env_instructor_hint", keyValues );
	
	EntityOutputs.AddOutput(button, "OnTimeUp", "!self", "Kill", "", 0.15, -1);
	EntityOutputs.AddOutput(button, "OnTimeUp", pickup.GetName(), "Kill", "", 0.0, -1);
	EntityOutputs.AddOutput(button, "OnTimeUp", keycard_hint_point.GetName(), "Kill", "", 0.0, -1);
	EntityOutputs.AddOutput(button, "OnTimeUp", keycard_hint.GetName(), "Kill", "", 0.0, -1);
	EntityOutputs.AddOutput(button, "OnTimeUp", "!activator", "RunScriptCode", "KeyPickup(self)", 0, -1);
	
	::KeyPickup <- function(activator) {
	
		EmitSoundOnClient("Christmas.GiftPickup" activator)
		QueueSpeak(activator, "KillSteal", 0, "");
		
		local melee = SpawnEntityFromTable("weapon_melee_spawn", {
			melee_weapon = "keycard",
			spawnflags = 2,
			count = 1,
			origin = activator.GetCenter()
		});
	
		DoEntFire("!self", "Use", "", 0, activator, melee);
		//Enable Trigger
        EntFire("card_check", "Enable");
	}
	
}

KeyCardDropper <- {}

KeyCardDropper.OnGameEvent_player_death <- function ( params )
{
	if (!("userid" in params)) return;
		
	local userid = GetPlayerFromUserID(params.userid);
	local model = userid.GetModelName()
	printl( "guh?");
	
	if(model == "models/infected/hulk_requiem_02.mdl" )
    {
		local Place = NavMesh.GetNearestNavArea(userid.GetOrigin() , 200.0 , false , false)
		EmitSoundOn("Christmas.GiftDrop" userid)
		EmitSoundOn("Christmas.GiftDrop" userid)
		CreatePickup(Place)
		NetProps.SetPropInt(userid, "m_nBody", 1);
		
	}	
}

KeyCardDropper.OnGameEvent_round_start_post_nav <- function ( params )
{
    local HulkTrain = "models/infected/hulk_requiem_02.mdl";
    if(!IsModelPrecached(HulkTrain))
    PrecacheModel(HulkTrain)	
}

__CollectGameEventCallbacks(KeyCardDropper)
