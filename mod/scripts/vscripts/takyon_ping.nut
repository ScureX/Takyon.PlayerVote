global function PingInit
global function CommandPing

bool pingEnabled = true
float pingAverageTime = 3.0 // for how many seconds the ping should be measured to get an average. set 0.0 for current ping

array<string> spawnedPlayers = []

void function PingInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!ping", CommandPing)
    AddClientCommandCallback("!PING", CommandPing)
    AddClientCommandCallback("!Ping", CommandPing)

    // ConVar
    pingEnabled = GetConVarBool( "pv_ping_enabled" )
    pingAverageTime = GetConVarFloat( "pv_ping_average_time" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandPing(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED PING")
        if(!pingEnabled){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + COMMAND_DISABLED, false)
            return false
        }

        // maybe check when the last time was a player requested ping

        // check if player name was given
        int ping = 0
        if(args.len() > 0){
            // player not on server or substring unspecific
            if(!CanFindPlayerFromSubstring(args[0])){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], false)
                return false
            }

            // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
            string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])
            entity target = GetPlayerFromName(fullPlayerName)

            thread ShowPing(player, target, fullPlayerName)
            return true
        }

        // get ping from self
        thread ShowPing(player, player, player.GetPlayerName())
        return true
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function ShowPing(entity player, entity target, string fullPlayerName) {
    int pings = 1
    int pingAvg = GetPing(target)
    if(pingAverageTime != 0){
        float startTime = Time()
        while(Time() - startTime <= pingAverageTime){
            WaitFrame()
            int newPing = GetPing(target)
            pingAvg += newPing
            // only increment if it actually pings
            if(newPing != 0)
                pings++
        }
        pingAvg = (pingAvg/pings).tointeger()
    }

    // player who pinged left lol
    if(GetPlayerArray().find(player) == -1){
        return
    }

    Chat_ServerPrivateMessage(player, fullPlayerName + ": " + pingAvg + "ms",false)
    return
}

int function GetPing(entity target){
    // need to error handle cause user can just disconnect
    try {
        return target.GetPlayerGameStat(PGS_PING)/100000
    } catch (exception){
        return 0
    }
}