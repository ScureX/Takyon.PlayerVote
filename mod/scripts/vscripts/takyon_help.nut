global function HelpInit

array<string> spawnedPlayers = []
int displayHintOnSpawnAmount = 0


void function HelpInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)

    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)

    // ConVar
    displayHintOnSpawnAmount = GetConVarInt( "pv_display_hint_on_spawn_amount" )
    #endif
}

/*
 *  COMMAND LOGIC
 */

bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        string commands =   "[ !skip, !extend, !kick ]\n"
        string skip =       "[ !skip   -> to skip the map]\n"
        string extend =     "[ !extend -> to play this map longer]\n"
        string kick =       "[ !kick   -> to kick a player]"
        SendHudMessageBuilder(player, commands + skip + extend + kick, 200, 200, 255)
    }
    return true
}

/*
 *  HELP HINT MESSAGE LOGIC
 */

void function OnPlayerSpawned(entity player){
    // this prevents the message from being displayed every time someone spawns, which would be annoying. so we dont do that :)
    int spawnAmount = 0
    foreach (name in spawnedPlayers)  {
        if (name == player.GetPlayerName())  {
            spawnAmount++
        }
    }   

    if(spawnedPlayers.find(player.GetPlayerName()) == -1 || spawnAmount <= displayHintOnSpawnAmount){
        SendHudMessageBuilder(player, "Open your console and type !help", 200, 200, 255) // Message that gets displayed on respawn
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