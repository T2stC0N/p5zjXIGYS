::HulkTrain <- function(activator) 
{
	local HulkTrain = "models/infected/hulk_dlc3.mdl";
	if(!IsModelPrecached(HulkTrain))
	PrecacheModel(HulkTrain)

    activator.SetModel(HulkTrain);
}
