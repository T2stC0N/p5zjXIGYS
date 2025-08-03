Msg("ENDisNeigh\n");

Convars.SetValue("z_witch_health", "600");
Convars.SetValue("z_witch_speed", "150");
Convars.SetValue("z_witch_damage", "50");
Convars.SetValue("director_afk_timeout", "999");


DirectorOptions <-
{
		ProhibitBosses = true

	// Special Infected settings
		SpecialRespawnInterval = 30
		MaxSpecials = 20
		SmokerLimit = 1
		SpitterLimit = 2
        JockeyLimit = 1
        BoomerLimit = 5
        HunterLimit = 2
        ChargerLimit = 2

	// Common Infected Settings
		MobMinSize = 50
		MobMaxSize = 150
		CommonLimit = 150
		ZombieSpawnRange = 500
}