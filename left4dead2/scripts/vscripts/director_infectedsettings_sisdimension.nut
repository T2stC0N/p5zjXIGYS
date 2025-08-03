Msg("Charger\n");

Convars.SetValue("z_charger_max_force", "8000");
Convars.SetValue("z_charge_duration", "9");
Convars.SetValue("z_charge_max_speed", "1500");
Convars.SetValue("z_charge_interval", "0.1");
Convars.SetValue("z_charge_warmup", "1");

 
DirectorOptions <-
{
	// Random Tank/Witch
		ProhibitBosses = false
		
	// Special Infected settings
		SpecialRespawnInterval = 30
		MaxSpecials = 10
		SmokerLimit = 0
		SpitterLimit = 0
        JockeyLimit = 0
        BoomerLimit = 0
        HunterLimit = 0
        ChargerLimit = 2
		
	// Common Infected Settings
		MobMinSize = 10
		MobMaxSize = 35
		CommonLimit = 100
		ZombieSpawnRange = 2000
}