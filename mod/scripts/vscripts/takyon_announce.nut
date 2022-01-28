global function AnnounceInit

bool announceEnabled = true // true: users can use !rules | false: users cant use !rules

void function AnnounceInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!announce", CommandAnnounce)
    AddClientCommandCallback("!ANNOUNCE", CommandAnnounce)
    AddClientCommandCallback("!Announce", CommandAnnounce)
    #endif
}

/*
 *  COMMAND LOGIC
 */

bool function CommandAnnounce(entity player, array<string> args){
    #if SERVER
    if(!IsLobby()){
        printl("USER USED ANNOUNCE")

        // check if !announce is enabled
        if(!announceEnabled){
            SendHudMessageBuilder(player, "This command has been disabled", 255, 200, 200)
            return false
        }

        // check if theres something after !announce
        if(args.len() < 1){
            SendHudMessageBuilder(player, "No message found\n!announce message", 255, 200, 200)
            return false
        }

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, "Missing Privileges!", 255, 200, 200)
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
    #endif
    return true
}