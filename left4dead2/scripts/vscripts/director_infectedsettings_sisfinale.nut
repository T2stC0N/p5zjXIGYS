Msg("BIGSIS\n");
 
DirectorOptions <-
{
	// Random Tank/Witch
		ProhibitBosses = false
		
	// Special Infected settings
		SpecialRespawnInterval = 99999999999999
		MaxSpecials = 90
		SmokerLimit = 30
		SpitterLimit = 30
        JockeyLimit = 30
        BoomerLimit = 30
        HunterLimit = 30
        ChargerLimit = 30
		
		MobSpawnMinTime = 1
		MobSpawnMaxTime = 1
		MobMinSize = 50
		MobMaxSize = 150
		MobMaxPending = 90
		SustainPeakMinTime = 15
		SustainPeakMaxTime = 18
		IntensityRelaxThreshold = 0.95
		RelaxMinInterval = 2
		RelaxMaxInterval = 5
		RelaxMaxFlowTravel = 1000
		ZombieTankHealth = 9999
		PreferredMobDirection = SPAWN_ABOVE_SURVIVORS
}


Director.ResetMobTimer()