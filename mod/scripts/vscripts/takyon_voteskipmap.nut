global function VoteSkipMapInit

array<string> playerVotedNames = [] // list of players who have voted, is used to see how many have voted 

void function VoteSkipMapInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!skip", CommandSkip)
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)

    AddClientCommandCallback("!rtv", CommandSkip) // rock the vote. requested by @Hedelma
    AddClientCommandCallback("!RTV", CommandSkip)

    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)
    #endif
}

#if SERVER
bool function CommandSkip(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED VOTING")
        
        if(playerVotedNames.find(player.GetPlayerName()) == -1){  // not voted yet 
            playerVotedNames.append(player.GetPlayerName())

            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                if(playerVotedNames.len() > 1) // semantics
                    SendHudMessageBuilder(GetPlayerArray()[i], playerVotedNames.len() + " Players Want To Skip This Map\nSkip this map by typing !skip in the console", 255, 200, 200)
                else
                    SendHudMessageBuilder(GetPlayerArray()[i], playerVotedNames.len() + " Player Wants To Skip This Map\nSkip this map by typing !skip in the console", 255, 200, 200)
			}
        } 
        else {
            // Doesnt let the player vote twice, name is saved so even on reconnect they cannot vote twice
            // Future update might check if the player is actually online but right now i am too tired
            SendHudMessageBuilder(player, "You have already voted!", 255, 200, 200)
        }
    }
    
    // check if enough have voted
    // change "half" in the if statement to whatever var or amount you want
    int half = ceil(1.0 * GetPlayerArray().len()/2).tointeger()
    int quater = ceil(1.0 * GetPlayerArray().len()/4).tointeger()

    if(playerVotedNames.len() >= 2){ //CHANGE
        SetServerVar("gameEndTime", 1.0) // end this game 
        playerVotedNames.clear()
    }

    return true
}
#endif

#if SERVER
bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        SendHudMessageBuilder(player, "Open your console and type !skip or !rtv to skip this map!", 200, 200, 255)
    }
    return true
}
#endif

#if SERVER
void function SendHudMessageBuilder(entity player, string message, int r, int g, int b){
    // SendHudMessage(player, message, x_pos, y_pos, R, G, B, A, fade_in_time, hold_time, fade_out_time)
    // Alpha doesnt work properly and is dependant on the RGB values for whatever fucking reason
    SendHudMessage( player, message, -1, 0.2, r, g, b, 255, 0.15, 6, 1 )
}
#endif