global function VoteSkipMapInit

array<string> playerVotedNames = [] // list of players who have voted, is used to see how many have voted 

void function VoteSkipMapInit(){
    #if SERVER
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
            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                MessageToPlayer(GetPlayerArray()[i], eEventNotifications.PlayerWantsToSkip)
			}
        } 
        else {
            MessageToPlayer(player, eEventNotifications.PlayerAlreadyVoted)
        }
    }
    
    // check if enough have voted
    // change "half" in the if statement to whatever var or amount you want
    int half = ceil(1.0 * GetPlayerArray().len()/2).tointeger()
    int quater = ceil(1.0 * GetPlayerArray().len()/4).tointeger()

    if(playerVotedNames.len() >= half){ //CHANGE
        SetServerVar("gameEndTime", 1.0) // end this game 
        for(int i = 0; i < GetPlayerArray().len(); i++){
            MessageToPlayer(GetPlayerArray()[i], eEventNotifications.SkipMap)
        }
        playerVotedNames.clear()
    }

    return true
}
#endif

#if SERVER
bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        MessageToPlayer(player, eEventNotifications.PlayerHelp)
    }
    return true
}
#endif