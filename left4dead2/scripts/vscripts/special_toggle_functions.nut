printl("Initiating Special_Toggle_Functions.nut")
//SI STUFF
//--------------------------------------------------------------------
function boomer_on(){
	Convars.SetValue("boomer_vomit_delay" 1)
}

function boomer_off(){
	Convars.SetValue("boomer_vomit_delay" 3600)
}

function spitter_on(){
	Convars.SetValue("z_spitter_range" 200)
}

function spitter_off(){
	Convars.SetValue("z_spitter_range" 0)
}

function smoker_on(){
	Convars.SetValue("smoker_tongue_delay" 1.5)
}

function smoker_off(){
	Convars.SetValue("smoker_tongue_delay" 3600)
}

function tankrumble_on(){
	Convars.SetValue("z_tank_footstep_shake_amplitude",5)
}

function tankrumble_off(){
	Convars.SetValue("z_tank_footstep_shake_amplitude",0)
}
//Glows
//--------------------------------------------------------------------

function glow_far_off(){
	Convars.SetValue("sv_disable_glow_faritems",1)
	Convars.SetValue("sv_disable_glow_survivors",1)
	Say( null, "Far Glows Off", false )
}

function glow_far_on(){
	Convars.SetValue("sv_disable_glow_faritems",0)
	Convars.SetValue("sv_disable_glow_survivors",0)
	Say( null, "Far Glows On", false )
}

function glow_all_off(){
	Convars.SetValue("cl_glow_blur_scale",0)
	Say( null, "All Glows Off", false )
}

function glow_all_on(){
	Convars.SetValue("cl_glow_blur_scale",3)
	Convars.SetValue("sv_disable_glow_faritems",0)
	Convars.SetValue("sv_disable_glow_survivors",0)
	Say( null, "All Glows On", false )
}
//Various TUMTaRA Cheat buttons.
//--------------------------------------------------------------------

function Cleanup(){ //REQUIRES SV_CHEATS 1
	SendToServerConsole("cl_destroy_ragdolls")
	SendToServerConsole("ent_remove_all infected")
	SendToServerConsole("r_cleardecals")
}

function nb_stop(Tiddies) {
    Convars.SetValue("nb_stop", Tiddies)
}
