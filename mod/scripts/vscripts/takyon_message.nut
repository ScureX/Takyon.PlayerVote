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
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + COMMAND_DISABLED, false)
            return false
        }

        // check for name after !msg
        if(args.len() < 1){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_PLAYERNAME_FOUND, false)
            return false
        }

        // check for message after !msg
        if(args.len() < 2){
            Chat_ServerPrivateMessage(player,"\x1b[38;2;220;0;0m" + NO_MESSAGE_FOUND + HOW_TO_MESSAGE, false)
            return false
        }
            
        // check if player substring exists n stuff
        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], false)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES, false)
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
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + PLAYER_IS_NULL, false)
            return false
        }

        // send message 
        Chat_ServerPrivateMessage(player, MESSAGE_SENT_TO_PLAYER + fullPlayerName, false)
        Chat_ServerPrivateMessage(target, msg, false)
    }
    return true
}