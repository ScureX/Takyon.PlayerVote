global function HelpInit
global function CommandHelp
global function CommandDiscord
global function CommandGetUid

string discordLink = ""  //put your discord link in mod.json
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
    AddClientCommandCallback("!getuid", CommandGetUid)
    AddClientCommandCallback("!discord", CommandDiscord)

    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)

    // ConVar
    helpEnabled = GetConVarBool( "pv_help_enabled" )
    displayHintOnSpawnAmount = GetConVarInt( "pv_display_hint_on_spawn_amount" )
    discordLink = GetConVarString( "pv_discord" )
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
                    SendHudMessageBuilder(player, commandArr[i].usage, 255, 255, 255)
                    return true
                }
            }
        }
        SendHudMessageBuilder(player, commands, 255, 255, 255)
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

bool function CommandDiscord(entity player, array<string> args){
    if(!IsLobby()){
        SendHudMessageBuilder(player, discordLink, 255, 255, 255)
        return true
    }
    return false
}

bool function CommandGetUid(entity player, array<string> args){
    if(!IsLobby()){
        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
            return false
        }

        // no player name given
        if(args.len() == 0){
            SendHudMessageBuilder(player, NO_PLAYERNAME_FOUND, 255, 200, 200)
            return false
        }

        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            SendHudMessageBuilder(player, CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], 255, 200, 200)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])
        SendHudMessageBuilder(player, fullPlayerName + ": " + GetPlayerFromName(fullPlayerName).GetUID(), 255, 255, 255)
        return true
    }

    /* Player in lobby -> UID will be sent to server console. check logs later */

    // no player name given
    if(args.len() == 0){
        return false
    }

    // Check if user is admin
    if(!IsPlayerAdmin(player)){
        return false
    }

    // player not on server or substring unspecific
    if(!CanFindPlayerFromSubstring(args[0])){
        return false
    }

    // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
    string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

    printl("REQUESTED UID FOR " + fullPlayerName + ": " + GetPlayerFromName(fullPlayerName).GetUID())
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