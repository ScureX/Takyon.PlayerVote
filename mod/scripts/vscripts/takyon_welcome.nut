global function WelcomeInit
global function ShowWelcomeMessage
global function OnPlayerSpawnedWelcome
global function OnPlayerDisconnectedWelcome

global bool welcomeEnabled = true
global array<string> welcomeSpawnedPlayers = []

// ADD YOUR FUCKING SERVER NAME IN mod.json I BEG YOU
string serverName = ""

//Add your discord server link or website in mod.json
string discordLink = "discord.gg/northstar"

// TODO maybe make convar
string welcomeMsg = ""

void function WelcomeInit(){
    // ConVar
    welcomeEnabled = GetConVarBool( "pv_welcome_enabled" )
    serverName = GetConVarString( "pv_servername" )

    if(GetConVarString( "pv_discord" ) != ""){
        discordLink = GetConVarString("pv_discord")
    }
    // change your welcome msg here
    welcomeMsg =    "Welcome %playername%!\n" + // leave %playername% so the msg is personalized
                    "You're now playing on " + serverName + "\n"+
                    "Join us at " + discordLink + "\n" + // add your discord or website
                    "Type !help in console or chat. -enablechathooks must be active for chat" // add -enablechathooks to \Titanfall2\ns_startup_args_dedi.txt
}

/*
 *  WELCOME MESSAGE LOGIC
 */

void function OnPlayerSpawnedWelcome(entity player){
    if(!mapsHaveBeenProposed && welcomeEnabled && welcomeSpawnedPlayers.find(player.GetPlayerName()) == -1){ // prioritizing the vote instead of showing help
        //ShowWelcomeMessage(player)
        welcomeSpawnedPlayers.append(player.GetPlayerName())
    }
}

void function OnPlayerDisconnectedWelcome(entity player){
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