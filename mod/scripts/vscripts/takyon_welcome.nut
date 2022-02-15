global function WelcomeInit
global function ShowWelcomeMessage

global bool welcomeEnabled = true
global array<string> welcomeSpawnedPlayers = []

// ADD YOUR FUCKING SERVER NAME IN mod.json I BEG YOU
string serverName = ""

// TODO maybe make convar
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
    if(!mapsHaveBeenProposed && welcomeEnabled && welcomeSpawnedPlayers.find(player.GetPlayerName()) == -1){ // prioritizing the vote instead of showing help
        //ShowWelcomeMessage(player)
        welcomeSpawnedPlayers.append(player.GetPlayerName())
    }
}

void function OnPlayerDisconnected(entity player){
    // remove player from list so on reconnect they get the message again
    while(welcomeSpawnedPlayers.find(player.GetPlayerName()) != -1){
        try{
            welcomeSpawnedPlayers.remove(welcomeSpawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling
    }
}

/*
 *  HELPER FUNCTIONS
 */

void function ShowWelcomeMessage(entity player){
    SendHudMessageBuilder(player, WelcomeMsgBuilder(welcomeMsg, player), 255, 255, 255) // Message that gets displayed on respawn
}

string function WelcomeMsgBuilder(string msg, entity player){
    string playerName = "%playername%"
    string finMsg = StringReplace(msg, playerName, player.GetPlayerName())
    return finMsg
}