::TougherTank <- function(activator) 
{
	local health = activator.GetHealth();
	activator.SetHealth(health + 4000);
	NetProps.SetPropFloat(activator, "m_flLaggedMovementValue", 1.5 );
}
