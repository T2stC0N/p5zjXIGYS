Msg("BOSS\n");
 
DirectorOptions <-
{
		ProhibitBosses = false
		
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