global function AnnounceInit
global function CommandAnnounce

bool announceEnabled = false // true: users can use !rules | false: users cant use !rules //CHANGE

void function AnnounceInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!announce", CommandAnnounce)
    AddClientCommandCallback("!ANNOUNCE", CommandAnnounce)
    AddClientCommandCallback("!Announce", CommandAnnounce)

    // ConVar
    announceEnabled = GetConVarBool( "pv_announce" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandAnnounce(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED ANNOUNCE")

        // check if !announce is enabled
        if(!announceEnabled){
            Chat_ServerPrivateMessage(player,"\x1b[38;2;220;0;0m" + COMMAND_DISABLED,false)
            return false
        }

        // check if theres something after !announce
        if(args.len() < 1){
            Chat_ServerPrivateMessage(player,"\x1b[38;2;220;0;0m" + NO_ANNOUNCEMENT_FOUND, 255, 200, 200)
            return false
        }

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            Chat_ServerPrivateMessage(player,"\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES, 255, 200, 200)
            return false
        }

        // build message
        string msg = ""
        for(int i = 0; i < args.len(); i++){
            msg += args[i] + " " // add space
        }

        // send message 
        for(int j = 0; j < GetPlayerArray().len(); j++){
            SendHudMessageBuilder(GetPlayerArray()[j], msg, 255, 200, 200)
        }
    }
    return true
}