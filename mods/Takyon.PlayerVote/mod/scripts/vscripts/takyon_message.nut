global function MessageInit
global function CommandMsg

bool messageEnabled = true // true: users can use !rules | false: users cant use !rules

void function MessageInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!msg", CommandMsg)
    AddClientCommandCallback("!MSG", CommandMsg)
    AddClientCommandCallback("!Msg", CommandMsg)

    // ConVar
    messageEnabled = GetConVarBool( "pv_message" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandMsg(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED MSG")

        // check if !msg is enabled
        if(!messageEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // check for name after !msg
        if(args.len() < 1){
            SendHudMessageBuilder(player, NO_PLAYERNAME_FOUND, 255, 200, 200)
            return false
        }

        // check for message after !msg
        if(args.len() < 2){
            SendHudMessageBuilder(player, NO_MESSAGE_FOUND + HOW_TO_MESSAGE, 255, 200, 200)
            return false
        }
            
        // check if player substring exists n stuff
        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            SendHudMessageBuilder(player, CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], 255, 200, 200)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
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
            SendHudMessageBuilder(player, PLAYER_IS_NULL, 255, 200, 200)
            return false
        }

        // send message 
        SendHudMessageBuilder(player, MESSAGE_SENT_TO_PLAYER + fullPlayerName, 255, 200, 200)
        SendHudMessageBuilder(target, msg, 255, 200, 200)
    }
    return true
}