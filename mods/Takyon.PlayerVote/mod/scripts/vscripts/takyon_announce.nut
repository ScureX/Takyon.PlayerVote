global function AnnounceInit

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
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // check if theres something after !announce
        if(args.len() < 1){
            SendHudMessageBuilder(player, NO_ANNOUNCEMENT_FOUND, 255, 200, 200)
            return false
        }

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
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