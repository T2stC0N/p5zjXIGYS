function ForceBotWalk() {
    if(IsPlayerABot(activator)) {
        local flags = NetProps.GetPropInt(activator, "m_afButtonForced");
        NetProps.SetPropInt(activator, "m_afButtonForced", flags | 131072);
    }
}

function EndBotWalk() {
    if(IsPlayerABot(activator)) {
        local flags = NetProps.GetPropInt(activator, "m_afButtonForced");
        NetProps.SetPropInt(activator, "m_afButtonForced", flags & ~131072);
    }
}

function OnPostSpawn() {
    self.ConnectOutput("OnStartTouch", "ForceBotWalk");
    self.ConnectOutput("OnEndTouch", "EndBotWalk");
}