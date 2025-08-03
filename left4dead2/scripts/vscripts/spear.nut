::Spear <- {}

Spear.OnGameEvent_item_pickup <- function ( params )
{
	if (!("userid" in params)) return; //How
	local userid = GetPlayerFromUserID(params.userid);
	if (userid.GetActiveWeapon() != "weapon_melee" && NetProps.GetPropString(userid.GetActiveWeapon(), "m_strMapSetScriptName") != "spear") return;
	
	//Fix the pistol free money glitch 2025 working
	local handPos = userid.GetBoneOrigin(userid.LookupBone("ValveBiped.Bip01_R_Hand"));
	local dropped_pistol = null;
	while (dropped_pistol = Entities.FindByClassnameWithin(dropped_pistol, "weapon_pistol", handPos, 150.0))
	{	
		if ("IsAutoGiven" in dropped_pistol.GetScriptScope())
		{
			if(dropped_pistol.GetOwnerEntity() == null){
				dropped_pistol.Kill(); // delete this dupe pistol
			}
		}
	}

	
	userid.ValidateScriptScope();
	local scope = userid.GetScriptScope();	

	if ("SeenSpearHint" in scope) return;
	
	local keyValues =
	{
		hint_name  = "explain_spear",
		hint_static = "1",
		//hint_nooffscreen = "0",
		hint_caption = "Hold R, then swing to throw the spear",
		hint_instance_type = "2",
		hint_binding = "+reload",
		hint_icon_onscreen = "use_binding",
		hint_color = "255 255 255",
		hint_timeout = "5",
		hint_display_limit = "3",
		hint_auto_start = "0",
		hint_forcecaption = "0",
		hint_allow_nodraw_target = "1",
		targetname = "door_hint01"
		origin = userid.GetOrigin(),
	}
	local spear_hint = SpawnEntityFromTable( "env_instructor_hint", keyValues );
	DoEntFire("!self", "ShowHint", "userid.GetName()", 0.1, userid, spear_hint);
	EntFire( spear_hint, "Kill", "", 5, null );
	
	scope.SeenSpearHint <- 1;
}

::DoGesture <- function(userid, animation, layer) 
{
	//Make sure we dont fill console with errors
	if ( userid.LookupSequence(animation) == -1)
		return;
		
	NetProps.SetPropIntArray(userid, "m_NetGestureSequence", userid.LookupSequence(animation), layer);
	NetProps.SetPropIntArray(userid, "m_NetGestureActivity", userid.LookupActivity(animation), layer);
	NetProps.SetPropFloatArray(userid, "m_NetGestureStartTime", Time(), layer);
}

Spear.OnGameEvent_weapon_fire <- function ( params )
{
	if (!("userid" in params)) return;
	local userid = GetPlayerFromUserID(params.userid);
	if (params.weapon != "melee") return; // - Don't want this
	if (params.weaponid != 19) return; // - Don't want this
	
	local reload = ((userid.GetButtonMask() & (1 << 13)) > 0)
		local PlayerWep = userid.GetActiveWeapon();
	
	if ( PlayerWep = "weapon_melee" && NetProps.GetPropString(PlayerWep , "m_strMapSetScriptName") == "spear" && reload ){
		
			ThrowMelee(userid);
			
			local velocity = userid.GetVelocity() 
			local speed = velocity.Length()  	
			
			if (speed > 70)
				DoGesture(userid, "ACT_PRIMARYATTACK_GREN2_RUN", 5)
			else
				DoGesture(userid, "ACT_PRIMARYATTACK_GREN2_IDLE", 5)
			
			local invTable = {}
			GetInvTable(userid, invTable)
			if("slot1" in invTable) {
			invTable.slot1.Kill();}
			
			EmitAmbientSoundOn(")player/survivor/swing/swing_miss1.wav", 0.76 , 85 , 100 , userid)// Sounds!
			
			userid.GiveItem("weapon_pistol")
			local pistol = userid.GetActiveWeapon();
			pistol.ValidateScriptScope();
			pistol.GetScriptScope().IsAutoGiven <- true;
		
		}
}
local MELEE_MODEL = "models/props_street/garbage_can.mdl";
local THROW_SPEED = 900.0;   // units / second
local LIFETIME    = 5.0;     // seconds before autocleanup

local worldspawn = Entities.First();

::ThrowMelee <- function(player)
{
    // Safety checks
    if ( !player || !player.IsValid() ) return;

    //-----------------------------------------------------
    // 1. Spawn the physics prop
    //-----------------------------------------------------
    local propName = UniqueString( "thrown_melee_" );

    // Start point: just in front of the survivor’s eyes
    local startPos = player.EyePosition() + player.GetForwardVector() * 20;

    local prop = SpawnEntityFromTable( "weapon_melee",
    {
        targetname       = propName,
        //model            = MELEE_MODEL,
        melee_script_name            = "spear",
        origin           = startPos.ToKVString(),
        angles           = player.EyeAngles().ToKVString(),
        spawnflags       = 256,     // debris (ignores team collision push)
        physdamagescale  = 0,       // we’re not using physics damage yet
        health           = 1
    });

    if ( !prop || !prop.IsValid() ) return;   // bail if the spawn failed

    //-----------------------------------------------------
    // 2. Launch it!
    //-----------------------------------------------------
    //local forward  = player.GetForwardVector(); // - Old Func
	//AnglesToForward(player.EyeAngles(), forward); // convert pitch/yaw to direction
	
	//idk, math shit
	function AnglesToForward(angles) {
		local pitch = angles.x * 0.017453292;
		local yaw = angles.y * 0.017453292;
	
		return Vector(
			cos(pitch) * cos(yaw),
			cos(pitch) * sin(yaw),
			-sin(pitch)
		);
	}
	local forward = AnglesToForward(player.EyeAngles());
	
    local velocity = forward * THROW_SPEED + Vector( 0, 0, 120 );  // 120 Zboost = gentle arc
    prop.ApplyAbsVelocityImpulse( velocity );

    // Add a spin so it looks fancy
    prop.ApplyLocalAngularVelocityImpulse( Vector( 1200, 0, 0 ) );

    //-----------------------------------------------------
    // 3. Clean up after a few seconds
    //-----------------------------------------------------
    //EntFire( propName, "Kill", "", LIFETIME, null );
	
	
	//-----------------------------------------------------
    // 4. Aids
    //-----------------------------------------------------
	local PropID = prop.GetEntityIndex();
	prop.ValidateScriptScope();
    local scope = prop.GetScriptScope();
	
	scope.lastPos <- prop.GetOrigin();
	
	scope.Ouch <- function(){

		local curPos = self.GetOrigin();
        local delta  = curPos - this.lastPos;
        this.lastPos = curPos;
		
		// If we’re barely moving, don’t do damage
        if (delta.Length() < 5.0){
			AddThinkToEnt(prop, "");
			//NetProps.SetPropInt(prop, "m_MoveType", 0)
			//EmitSoundOn("Spear.Impale" prop) // Sounds!
			

			// Get spear's facing direction
			local forward = self.GetAngles().Forward(); // this gives direction based on current rotation
			
			// Trace a short distance ahead
			local traceTable = {};
			traceTable.start <- self.GetOrigin();
			traceTable.end   <- traceTable.start + forward * 76;
			//traceTable.mask  <- TRACE_MASK_PLAYER_SOLID;
			traceTable.ignore <- self;
			
			//DebugDrawLine(traceTable.start, traceTable.end, 255, 255, 0, true, 7); // Yellow line downward
			
			if (TraceLine(traceTable) && traceTable.hit)
			{
				// Check if it's a steep surface (like a wall)
				//if (abs(traceTable.planeNormal.z) < 0.5)
				//{
					// Do the embed stuff here
					//DebugDrawBox(traceTable.pos, Vector(-2,-2,-2), Vector(2,2,2), 255, 0, 0, 8, 5.0);
			
					// Optional: move spear a bit into wall and freeze it
					self.SetOrigin(self.GetOrigin() + forward * 20);
					NetProps.SetPropInt(self, "m_MoveType", 0);
					EmitSoundOn("Spear.Impale", self);
				//}
			}

			
		}
		
		//Zombie Found
		local infected = null;
		while(infected = Entities.FindByClassnameWithin( infected, "infected", prop.GetOrigin(), 25 ))
		{	
			//Blood Code
			local bloodlevel = NetProps.GetPropInt(prop, "m_iBloodyWeaponLevel");
			if(bloodlevel == 10)
				continue;
			
			NetProps.SetPropInt(prop, "m_iBloodyWeaponLevel", bloodlevel + 1);
			//Blood Code End
	
			infected.ValidateScriptScope();
			local scope_ci = infected.GetScriptScope();
			
			if ("BeenHit" in scope_ci)
				continue
			
			local dir = prop.GetVelocity();
			if ( dir.Length() < 1.0 )                         // stopped? fall back
				dir = infected.GetOrigin() - prop.GetOrigin();
			dir.Norm();                                       // unit length
			// 2)  Fixed impulse straight away from impact
			local force = dir * 4000;    
	
			infected.TakeDamageEx(player, player, null, force, prop.GetOrigin(), 9999, 16777216 );
			
			EmitSoundOn("Melee.Hit" infected) // Sounds!
			EmitSoundOn("Melee.HitLimb" infected) // Sounds!
			EmitSoundOn("Axe.ImpactFlesh" infected) // Sounds!
			
			//infected.TakeDamage(9999, 16777216, worldspawn) // Hurt them. Setting Witch as attacker makes the game fucking explode.
			
			scope_ci.BeenHit <- 1;
		}
		
		//Zombie Found
		local witch = null;
		while(witch = Entities.FindByClassnameWithin( witch, "witch", prop.GetOrigin(), 25 ))
		{	
			//Blood Code
			local bloodlevel = NetProps.GetPropInt(prop, "m_iBloodyWeaponLevel");
			if(bloodlevel == 10)
				continue;
			
			NetProps.SetPropInt(prop, "m_iBloodyWeaponLevel", bloodlevel + 1);
			//Blood Code End
	
			witch.ValidateScriptScope();
			local scope_witch = witch.GetScriptScope();
			
			if ("BeenHit" in scope_witch)
				continue
			
			local dir = prop.GetVelocity();
			if ( dir.Length() < 1.0 )                         // stopped? fall back
				dir = witch.GetOrigin() - prop.GetOrigin();
			dir.Norm();                                       // unit length
			// 2)  Fixed impulse straight away from impact
			local force = dir * 4000;    
	
			witch.TakeDamageEx(player, player, null, force, prop.GetOrigin(), 250, 64 );
			
			EmitSoundOn("Melee.Hit" witch) // Sounds!
			EmitSoundOn("Melee.HitLimb" witch) // Sounds!
			EmitSoundOn("Axe.ImpactFlesh" witch) // Sounds!
			
			//infected.TakeDamage(9999, 16777216, worldspawn) // Hurt them. Setting Witch as attacker makes the game fucking explode.
			
			scope_witch.BeenHit <- 1;
			DoEntFire("!self", "RunScriptCode", "ClearPlayer()" , 1.0 , null, witch);
		}
		
		local hit_player = null;
		while(hit_player = Entities.FindByClassnameWithin( hit_player, "player", prop.GetOrigin(), 15 ))
		{	
			//Blood Code
			local bloodlevel = NetProps.GetPropInt(prop, "m_iBloodyWeaponLevel");
			if(bloodlevel == 10)
				continue;
			
			NetProps.SetPropInt(prop, "m_iBloodyWeaponLevel", bloodlevel + 1);
			//Blood Code End
			
			if (!hit_player) continue
			if (hit_player == player) continue
			
			hit_player.ValidateScriptScope();
			local scope_player = hit_player.GetScriptScope();
			
			if ("BeenHit" in scope_player)
				continue
			
			local dir = prop.GetVelocity();
			if ( dir.Length() < 1.0 )                         // stopped? fall back
				dir = hit_player.GetOrigin() - prop.GetOrigin();
			dir.Norm();                                       // unit length
			// 2)  Fixed impulse straight away from impact
			local force = dir * 400000;    
	
			if (hit_player.IsSurvivor()){
				hit_player.TakeDamageEx(player, player, null, force, prop.GetOrigin(), 5, 128 );
				DoGesture(hit_player, "ACT_TERROR_FLINCH", 6)
			}
			else{
				hit_player.TakeDamageEx(player, player, null, force, prop.GetOrigin(), 600, 64 );
			}
			
			EmitSoundOn("Melee.Hit" hit_player) // Sounds!
			EmitSoundOn("Melee.HitLimb" hit_player) // Sounds!
			EmitSoundOn("Axe.ImpactFlesh" hit_player) // Sounds!
			
			//infected.TakeDamage(9999, 16777216, worldspawn) // Hurt them. Setting Witch as attacker makes the game fucking explode.
			
			scope_player.BeenHit <- 1;
			DoEntFire("!self", "RunScriptCode", "ClearPlayer()" , 1.0 , null, hit_player);
		}
		
		
		return -1
	}
	
	AddThinkToEnt(prop, "Ouch");
}

::ClearPlayer <- function() 
{
	if (!self || !self.IsValid()) return;

    local scope = self.GetScriptScope();
    if ("BeenHit" in scope)
    {
        scope.rawdelete("BeenHit");
    }
}

__CollectGameEventCallbacks(Spear);
