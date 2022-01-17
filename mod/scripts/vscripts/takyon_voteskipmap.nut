global function VoteSkipMapInit

int playersVoted
array<string> playerVotedNames = [] // list of players who have voted, is used to see how many have voted 

void function VoteSkipMapInit(){
    #if SERVER
    //TODO to lower?
    AddClientCommandCallback("!skip", CommandSkip)
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)

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
            playersVoted = playersVoted + 1

            SendHudMessage( player, "ASJHDOIHAdOSHDOHASOJDHJOASHD", -15, 6.2, 0, 0, 0, 255, 0, 6, 0 )

            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                if(playersVoted > 1){
                    SendHudMessageBuilder(GetPlayerArray()[i], playersVoted + " Players Want To Skip This Map! Skip this map by typing !skip in the console!", 255, 0, 0)
                }
                else{
                    SendHudMessageBuilder(GetPlayerArray()[i], playersVoted + " Player Wants To Skip This Map! Skip this map by typing !skip in the console!", 255, 0, 0)
                }
			}
        } 
        else {
            SendHudMessageBuilder(player, "You have already voted", 255, 0, 0)
        }
    }
    
    // check if enough have voted
    // change "half" in the if statement to whatever var or amount you want
    int half = ceil(1.0 * GetPlayerArray().len()/2).tointeger()
    int quater = ceil(1.0 * GetPlayerArray().len()/4).tointeger()

    if(playerVotedNames.len() >= 2){ //CHANGE
        SetServerVar("gameEndTime", 1.0) // end this game 
        playersVoted = 0
        playerVotedNames.clear()
    }

    return true
}
#endif

#if SERVER
bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        SendHudMessageBuilder(player, "Open your console and type !skip  to skip this map", 0, 0, 255)
    }
    return true
}
#endif

#if SERVER
void function SendHudMessageBuilder(entity player, string message, int r, int g, int b){
    // SendHudMessage(player, message, x_pos, y_pos, R, G, B, A, fade_in_time, hold_time, fade_out_time)
    SendHudMessage( player, message, 5, 6.2, 0, 0, 0, 255, 0.15, 6, 1 )
    SendHudMessage( player, message, -1, 0.2, r, g, b, 255, 0.15, 6, 1 )
}
#endif