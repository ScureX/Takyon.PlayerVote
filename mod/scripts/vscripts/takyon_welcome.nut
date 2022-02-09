global function WelcomeInit

global bool welcomeEnabled = true
array<string> spawnedPlayers = []

// ADD YOUR FUCKING SERVER NAME IN mod.json I BEG YOU
string serverName = ""

// change this lol // TODO maybe make convar
string welcomeMsg = ""

void function WelcomeInit(){
    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)

    // ConVar
    welcomeEnabled = GetConVarBool( "pv_welcome_enabled" )
    serverName = GetConVarString( "pv_servername" )

    // change your welcome msg here
    welcomeMsg =    "Welcome %playername%!\n" + // leave %playername% so the msg is personalized
                    "You're now playing on " + serverName + "\n"+
                    "Join us at discord.gg/northstar\n" + // add your discord or website
                    "Type !help in console"
}

/*
 *  WELCOME MESSAGE LOGIC
 */

void function OnPlayerSpawned(entity player){
    if(!mapsHaveBeenProposed && welcomeEnabled && spawnedPlayers.find(player.GetPlayerName()) == -1){ // prioritizing the vote instead of showing help
        SendHudMessageBuilder(player, WelcomeMsgBuilder(welcomeMsg, player), 255, 255, 255) // Message that gets displayed on respawn
        spawnedPlayers.append(player.GetPlayerName())
    }
}

void function OnPlayerDisconnected(entity player){
    // remove player from list so on reconnect they get the message again
    while(spawnedPlayers.find(player.GetPlayerName()) != -1){
        try{
            spawnedPlayers.remove(spawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling
    }
}

/*
 *  HELPER FUNCTIONS
 */

string function WelcomeMsgBuilder(string msg, entity player){
    string playerName = "%playername%"
    string finMsg = StringReplace(msg, playerName, player.GetPlayerName())
    return finMsg
}