//-----------------------------------------------------------------------------

PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3

//-----------------------------------------------------------------------------

SharedOptions <-
{

//==================================== TYPE A =============================================

	A_CustomFinale_StageCount = 9
	
 	A_CustomFinale1 = PANIC
	A_CustomFinaleMusic1 = ""
	A_CustomFinaleValue1 = 2
	
 	A_CustomFinale2 = PANIC
	A_CustomFinaleMusic2 = ""
	A_CustomFinaleValue2 = 1
	
	A_CustomFinale3 = TANK
	A_CustomFinaleMusic3 = ""
	A_CustomFinaleValue3 = 1
	
	A_CustomFinale4 = TANK
	A_CustomFinaleMusic4 = "event.tank"
	A_CustomFinaleValue4 = 1

	A_CustomFinale5 = DELAY
	A_CustomFinaleValue5 = 15

	A_CustomFinale6 = PANIC
	A_CustomFinaleMusic6 = ""
	A_CustomFinaleValue6 = 2

	A_CustomFinale7 = PANIC
	A_CustomFinaleMusic7 = ""
	A_CustomFinaleValue7 = 2
	
	A_CustomFinale8 = TANK
	A_CustomFinaleMusic8 = "event.tank"
	A_CustomFinaleValue8 = 2

	A_CustomFinale9 = DELAY
	A_CustomFinaleValue9 = 8

//==================================== TYPE B =============================================
	
	B_CustomFinale_StageCount = 9
	
	B_CustomFinale1 = PANIC
	B_CustomFinaleMusic1 = ""
	B_CustomFinaleValue1 = RandomInt( 1, 2 )
	
 	B_CustomFinale2 = TANK
	B_CustomFinaleMusic2 = "event.tank"
	B_CustomFinaleValue2 = RandomInt( 1, 2 )
	
	B_CustomFinale3 = DELAY
	B_CustomFinaleMusic3 = ""
	B_CustomFinaleValue3 = 20
	
	B_CustomFinale4 = PANIC
	B_CustomFinaleMusic4 = ""
	B_CustomFinaleValue4 = 1

	B_CustomFinale5 = PANIC
	B_CustomFinaleMusic5 = ""
	B_CustomFinaleValue5 = 2

	B_CustomFinale6 = PANIC
	B_CustomFinaleMusic6 = ""
	B_CustomFinaleValue6 = 1

	B_CustomFinale7 = DELAY
	B_CustomFinaleMusic7 = ""
	B_CustomFinaleValue7 = 9
	
	B_CustomFinale8 = TANK
	B_CustomFinaleMusic8 = "event.tank"
	B_CustomFinaleValue8 = 1

	B_CustomFinale9 = TANK
	B_CustomFinaleMusic9 = "event.tank"
	B_CustomFinaleValue9 = 1

//==================================== TYPE C =============================================
	
	C_CustomFinale_StageCount = 9
	
	C_CustomFinale1 = TANK
	C_CustomFinaleMusic1 = ""
	C_CustomFinaleValue1 = RandomInt( 1, 2 )
	
	C_CustomFinale2 = DELAY
	C_CustomFinaleMusic2 = ""
	C_CustomFinaleValue2 = 15
	
 	C_CustomFinale3 = PANIC
	C_CustomFinaleMusic3 = ""
	C_CustomFinaleValue3 = RandomInt( 1, 2 )
	
	C_CustomFinale4 = PANIC
	C_CustomFinaleMusic4 = ""
	C_CustomFinaleValue4 = 1

	C_CustomFinale5 = PANIC
	C_CustomFinaleMusic5 = ""
	C_CustomFinaleValue5 = 1

	C_CustomFinale6 = PANIC
	C_CustomFinaleMusic6 = ""
	C_CustomFinaleValue6 = 1

	C_CustomFinale7 = TANK
	C_CustomFinaleMusic7 = "event.tank"
	C_CustomFinaleValue7 = 1
	
	C_CustomFinale8 = TANK
	C_CustomFinaleMusic8 = "event.tank"
	C_CustomFinaleValue8 = 1
	
	C_CustomFinale9 = DELAY
	C_CustomFinaleValue9 = 10

//=================================================================================

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_ANYWHERE
	ShouldConstrainLargeVolumeSpawn = false

	SpecialRespawnInterval = 40
	
	ZombieSpawnRange = 2800
	ZombieSpawnInFog = true
 
	BoomerLimit = 2
	SmokerLimit = 2
	HunterLimit = 2
	SpitterLimit = 3
	JockeyLimit = 2
	ChargerLimit = 3
	
	DominatorLimit = 4
	SpecialInfectedAssault = 1

	MaxSpecials = 5
	CommonLimit = 40
	
	WaterSlowsMovement = 0
	
	MusicDynamicMobSpawnSize = 10
	MusicDynamicMobScanStopSize = 1
	MusicDynamicMobStopSize = 3
} 

InitialPanicOptions <-
{
}


PanicOptions <-
{
}

TankOptions <-
{
	SpecialRespawnInterval = 50
	CommonLimit = 25
}


DirectorOptions <- clone SharedOptions
{
}

//-----------------------------------------------------------------------------

function AddTableToTable( dest, src )
{
	foreach( key, val in src )
	{
		dest[key] <- val
	}
}

//-----------------------------------------------------------------------------

function OnBeginCustomFinaleStage( num, type )
{
	if ( developer() > 0 )
	{
		printl("========================================================");
		printl( "Beginning custom finale stage " + num + " of type " + type );
	}

	local waveOptions = null
	if ( num == 1 )
	{
		waveOptions = InitialPanicOptions
	}
	else if ( type == PANIC )
	{
		waveOptions = PanicOptions
		if ( "MegaMobMinSize" in PanicOptions )
		{
			waveOptions.MegaMobSize <- RandomInt( PanicOptions.MegaMobMinSize, MegaMobMaxSize )
		}
	}
	else if ( type == TANK )
	{
		waveOptions = TankOptions
	}
	
	//---------------------------------

	MapScript.DirectorOptions.clear()

	AddTableToTable( MapScript.DirectorOptions, SharedOptions );

	if ( waveOptions != null )
	{
		AddTableToTable( MapScript.DirectorOptions, waveOptions );
	}

	//---------------------------------

	if ( developer() > 0 )
	{
		Msg( "\n*****\nMapScript.DirectorOptions:\n" );
		foreach( key, value in MapScript.DirectorOptions )
		{
			Msg( "    " + key + " = " + value + "\n" );
		}

		if ( LocalScript.rawin( "DirectorOptions" ) )
		{
			Msg( "\n*****\nLocalScript.DirectorOptions:\n" );
			foreach( key, value in LocalScript.DirectorOptions )
			{
				Msg( "    " + key + " = " + value + "\n" );
			}
		}
		printl("========================================================");
	}
}
