global function MessageInit

bool messageEnabled = true // true: users can use !rules | false: users cant use !rules

void function MessageInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!msg", CommandMsg)
    AddClientCommandCallback("!MSG", CommandMsg)
    AddClientCommandCallback("!Msg", CommandMsg)

    // ConVar
    messageEnabled = GetConVarBool( "pv_message" )
    #endif
}

/*
 *  COMMAND LOGIC
 */

bool function CommandMsg(entity player, array<string> args){
    #if SERVER
    if(!IsLobby()){
        printl("USER USED MSG")

        // check if !msg is enabled
        if(!messageEnabled){
            SendHudMessageBuilder(player, "This command has been disabled", 255, 200, 200)
            return false
        }

        // check for name after !msg
        if(args.len() < 1){
            SendHudMessageBuilder(player, "No player found\n!msg playerName message", 255, 200, 200)
            return false
        }

        // check for message after !msg
        if(args.len() < 2){
            SendHudMessageBuilder(player, "No message found\n!msg playerName message", 255, 200, 200)
            return false
        }
            
        // check if player substring exists n stuff
        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            SendHudMessageBuilder(player, "Couldn't match one player for " + args[0], 255, 200, 200)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, "Missing Privileges!", 255, 200, 200)
            return false
        }

        // build message
        string msg = ""
        for(int i = 1; i < args.len(); i++){
            msg += args[i] + " " // add space
        }

        entity target = GetPlayerFromName(fullPlayerName)

        // last minute error handling if player cant be found
        if(target == null){
            SendHudMessageBuilder(player, "There was an error. The player might've left", 255, 200, 200)
            return false
        }

        // send message 
        SendHudMessageBuilder(target, msg, 255, 200, 200)
    }
    #endif
    return true
}