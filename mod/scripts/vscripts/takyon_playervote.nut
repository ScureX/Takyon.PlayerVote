global function PlayerVoteInit
global function SendHudMessageBuilder
global function CanFindPlayerFromSubstring
global function GetFullPlayerNameFromSubstring
global function PlayerHasVoted

// array<string> adminNames = ["Takyon_Scure"] // example
global array<string> adminNames = ["Takyon_Scure"] // list of usernames who should have admin privileges to execute commands like !rtv force // CHANGE

void function PlayerVoteInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    // admin commands
    // this will only work once i save shit like admin names in like a json file or sumn cause otherwise it will be reset on mapchange
    //AddClientCommandCallback("!admin", CommandHelp) // !admin add playername || !admin remove playernamepp
    #endif
}


/*
 *  HELPER FUNCTIONS
 */

bool function CanFindPlayerFromSubstring(string substring){
    #if SERVER
    int found = 0
    
    foreach(entity player in GetPlayerArray()){ // shitty solution but cant do .find cause its not an entity
        if(player.GetPlayerName().tolower().find(substring.tolower()) != null && player.GetPlayerName().tolower().find(substring.tolower()) != -1)
            found++
    }

    printl("found this many: " + found)

    if(found == 1){ 
        return true
    }
    #endif
    return false
}

string function GetFullPlayerNameFromSubstring(string substring){
    #if SERVER
    foreach(entity player in GetPlayerArray()){ // shitty solution but cant do .find cause its not an entity
        if(player.GetPlayerName().tolower().find(substring.tolower()) != null)
            return player.GetPlayerName()
    }
    #endif
    return "ERROR :(" // bad fix but this shouldnt even be possible to reach
}

bool function PlayerHasVoted(entity player, array<string> arr){
    #if SERVER
    if(arr.find(player.GetPlayerName()) == -1){  // not voted yet 
        return false
    } 
    #endif
    return true
}

void function SendHudMessageBuilder(entity player, string message, int r, int g, int b){
    #if SERVER
    // SendHudMessage(player, message, x_pos, y_pos, R, G, B, A, fade_in_time, hold_time, fade_out_time)
    // Alpha doesnt work properly and is dependant on the RGB values for whatever fucking reason
    SendHudMessage( player, message, -1, 0.2, r, g, b, 255, 0.15, 6, 1 )
    #endif
}
