global function HelpInit
global function CommandHelp

string version = "v3.1.0"
bool helpEnabled = true
int displayHintOnSpawnAmount = 0
bool useGeneratedHelp = true // will auto-generate text for the help command. set false if you want to input your own help text

array<string> spawnedPlayers = []
array<string> cmdArr = []

string commands =   "[ !skip, !extend, !kick, !rules, !switch, !balance, !ping, !vote ]"

void function HelpInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)

    // More or less only relevant for me to see what verison servers are on without contacting the owner
    AddClientCommandCallback("!version", CommandVersion)

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

        if(args.len() > 0){
            for(int i = 0; i < commandArr.len(); i++){
                if(commandArr[i].names.contains(args[0])){
                    SendHudMessageBuilder(player, commandArr[i].usage, 200, 200, 255)
                    return true
                }
            }
        }
        SendHudMessageBuilder(player, commands, 200, 200, 255)
    }
    return true
}

bool function CommandVersion(entity player, array<string> args){
    if(!IsLobby()){
        SendHudMessageBuilder(player, version, 255, 255, 255)
        return true
    }
    return false
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

    bool shouldWelcome = welcomeEnabled && spawnAmount == 0
    bool shouldDisplayHelp = spawnAmount <= displayHintOnSpawnAmount
    bool enoughTimeAfterMapProposal = Time() - mapsProposalTimeLeft > 10

    if(shouldWelcome && !mapsHaveBeenProposed){
        ShowWelcomeMessage(player)
    }
    else if(shouldDisplayHelp && (!mapsHaveBeenProposed || (enoughTimeAfterMapProposal && spawnAmount > 0))){
        SendHudMessageBuilder(player, HELP_MESSAGE, 200, 200, 255) // Message that gets displayed on respawn
    }
    spawnedPlayers.append(player.GetPlayerName())
}

void function OnPlayerDisconnected(entity player){
    // remove player from list so on reconnect they get the message again
    while(spawnedPlayers.find(player.GetPlayerName()) != -1){
        try{
            spawnedPlayers.remove(spawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling
    }
}