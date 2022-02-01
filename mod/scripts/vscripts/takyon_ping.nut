global function PingInit

bool pingEnabled = true
float pingAverageTime = 1.0 // for how many seconds the ping should be measured to get an average. set 0.0 for current ping

array<string> spawnedPlayers = []

void function PingInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!ping", CommandPing)
    AddClientCommandCallback("!PING", CommandPing)
    AddClientCommandCallback("!Ping", CommandPing)

    // ConVar
    helpEnabled = GetConVarBool( "pv_help_enabled" )
    displayHintOnSpawnAmount = GetConVarInt( "pv_display_hint_on_spawn_amount" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandPing(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED PING")
        if(!pingEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // maybe check when the last time was a player requested ping

        // check if player name was given
        int ping = 0
        if(args.len() > 0){
            // player not on server or substring unspecific
            if(!CanFindPlayerFromSubstring(args[0])){
                SendHudMessageBuilder(player, CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], 255, 200, 200)
                return false
            }

            // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
            string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])
            entity target = GetPlayerFromNAme(fullPlayerName)

            thread ShowPing(player, target)
            return true
        }

        // get ping from self
        thread ShowPing(player, player)
        return true
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function ShowPing(entity player, entity target) {
    int pings = 0
    int pingAvg = target.GetPlayerGameStat(PGS_PING)

    if(pingAverageTime != 0){
        float startTime = Time()
        while(Time() - startTime <= pingAverageTime){
            pingAvg += target.GetPlayerGameStat(PGS_PING)
            pings++
        }
        pingAvg = (pingAvg/pings).tointeger()
    }

    SendHudMessageBuilder(player, fullPlayerName + ": " + str(pingAvg) + "ms", 200, 200, 255)
    return
}