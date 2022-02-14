global function PlayerVoteInit
global function SendHudMessageBuilder
global function CanFindPlayerFromSubstring
global function GetFullPlayerNameFromSubstring
global function PlayerHasVoted
global function IsPlayerAdmin
global function GetPlayerFromName
global function rndint

global array<string> adminUIDs = []

void function PlayerVoteInit(){
    // chat callback
    AddCallback_OnReceivedSayTextMessage(ChatCallback)

    UpdateAdminList()
}

/*
 *  CHAT LOGIC
 */

// x3Karma if you steal this istg i will break your legs
ClServer_MessageStruct function ChatCallback(ClServer_MessageStruct message) {
    string msg = message.message.tolower()
    // find first char -> gotta be ! to recognize command 
    if (format("%c", msg[0]) == "!") {
        printl("Chat Command Found")
        // command
        msg = msg.slice(1) // remove !
        array<string> msgArr = split(msg, " ") // split at space, [0] = command
        string cmd = msgArr[0] // save command
        msgArr.remove(0) // remove command from args

        entity player = message.player

        // command logic
        for(int i = 0; i < commandArr.len(); i++){
            if(commandArr[i].names.contains(cmd)){
                message.shouldBlock  = commandArr[i].blockMessage
                commandArr[i].func(player, msgArr)
                break
            }
        }
    }
    return message
}

/*
 *  HELPER FUNCTIONS
 */

void function UpdateAdminList()
{
    string cvar = GetConVarString( "pv_admin_uids" )

    array<string> dirtyUIDs = split( cvar, "," )
    foreach ( string uid in dirtyUIDs )
        adminUIDs.append(strip(uid))
}

bool function CanFindPlayerFromSubstring(string substring){
    int found = 0
    foreach(entity player in GetPlayerArray()){ // shitty solution but cant do .find cause its not an entity
        if(player.GetPlayerName().tolower().find(substring.tolower()) != null && player.GetPlayerName().tolower().find(substring.tolower()) != -1)
            found++
    }

    if(found == 1){
        return true
    }
    return false
}

string function GetFullPlayerNameFromSubstring(string substring){
    foreach(entity player in GetPlayerArray()){ // shitty solution but cant do .find cause its not an entity
        if(player.GetPlayerName().tolower().find(substring.tolower()) != null)
            return player.GetPlayerName()
    }
    return "ERROR :(" // bad fix but this shouldnt even be possible to reach
}

bool function PlayerHasVoted(entity player, array<string> arr){
    if(arr.find(player.GetPlayerName()) == -1){  // not voted yet
        return false
    }
    return true
}

void function SendHudMessageBuilder(entity player, string message, int r, int g, int b, int holdTime = 6){
    // SendHudMessage(player, message, x_pos, y_pos, R, G, B, A, fade_in_time, hold_time, fade_out_time)
    // Alpha doesnt work properly and is dependant on the RGB values for whatever fucking reason
    SendHudMessage( player, message, -1, 0.2, r, g, b, 255, 0.15, holdTime, 1 )
}

bool function IsPlayerAdmin(entity player){
    if(adminUIDs.find(player.GetUID()) == -1)
        return false
    return true
}

entity function GetPlayerFromName(string name){
    entity target
    for(int i = 0; i < GetPlayerArray().len(); i++){
        if(name == GetPlayerArray()[i].GetPlayerName()){
            return GetPlayerArray()[i]
        }
    }
    return null
}

int function rndint(int max) {
    // Generate a pseudo-random integer between 0 and max
    float roll = 1.0 * max * rand() / RAND_MAX;
    return roll.tointeger();
}