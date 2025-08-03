Msg("Initiating Barricade Onslaught\n");

DirectorOptions <-
{

	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 5
	MobMinSize = 8
	MobMaxSize = 14
	MobMaxPending = 40
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 15
	IntensityRelaxThreshold = 0.9
	RelaxMinInterval = 6
	RelaxMaxInterval = 15
	RelaxMaxFlowTravel = 300

	PreferredSpecialDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredMobDirection = SPAWN_ANYWHERE
	ZombieSpawnRange = 3000

	SpecialRespawnInterval = 35
	ChargerLimit = 2
	SpitterLimit = 3
	
	DominatorLimit = 4

	CommonLimit = 40
	
	MusicDynamicMobSpawnSize = 10
	MusicDynamicMobScanStopSize = 1
	MusicDynamicMobStopSize = 3
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

