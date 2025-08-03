
::Yummers <- function(activator) {
	local health = activator.GetHealth();
	local healthbuffer = activator.GetHealthBuffer();
	local healamount = 0;
	local healcap = 200;	//Gen baby change this when needed

	switch(GetDifficulty())
	{
		case 0: healamount += 6; break;
		case 1: healamount += 10; break;
		case 2: healamount += 16; break;
		case 3: healamount += 25; break;
	}

	if ((health + healthbuffer) >= healcap)
		return;

	if (NetProps.GetPropInt(activator , "m_bIsOnThirdStrike") == 1)
	{
		healthbuffer += healamount;
		if (health + healthbuffer > healcap)
		{
			healthbuffer = healcap - health;
			if (healthbuffer < 0) healthbuffer = 0;
		}
		activator.SetHealthBuffer(healthbuffer);
	}
	else
	{
		health += healamount;
		if (health > healcap)
			health = healcap;

		activator.SetHealth(health);
		activator.SetHealthBuffer(healthbuffer);
	}

	QueueSpeak(activator, "RelaxedSigh", 0, "");
}


	