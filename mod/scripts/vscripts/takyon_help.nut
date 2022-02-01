global function HelpInit

bool helpEnabled = true
int displayHintOnSpawnAmount = 0
bool useGeneratedHelp = true // will auto-generate text for the help command. set false if you want to input your own help text

array<string> spawnedPlayers = []

string commands =   "[ !skip, !extend, !kick, !rules, !switch   ]"
string skip =       "[ !skip   -> to skip the map               ]"
string extend =     "[ !extend -> to play this map longer       ]"
string kick =       "[ !kick   -> to kick a player              ]"
string switchcmd =  "[ !switch -> to switch teams               ]"
// dont forget to add new strings in cmdArr
array<string> cmdArr = [commands, skip, extend, kick, switchcmd]


void function HelpInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)

    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)

    // ConVar
    helpEnabled = GetConVarBool( "pv_help_enabled" )
    displayHintOnSpawnAmount = GetConVarInt( "pv_display_hint_on_spawn_amount" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        if(!helpEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        string fullCmd = ""
        foreach (string cmd in cmdArr) {
            fullCmd += cmd + "\n"
        }

        SendHudMessageBuilder(player, fullCmd, 200, 200, 255)
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
        SendHudMessageBuilder(player, SPAWN_MESSAGE, 200, 200, 255) // Message that gets displayed on respawn
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
}try{
            spawnedPlayers.remove(spawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling