global function VoteSkipMapInit
global array<string> playerVotedNames // list of players who have voted, is used to see how many have voted 

void function VoteSkipMapInit(){
    #if SERVER
    AddClientCommandCallback("!skip", CommandSkip)
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)
    #endif
}

#if SERVER
bool function CommandSkip(entity player, array<string> args){
    if(!IsLobby()){
        printl("Want to skip " + GetMapName() + "? Type !skip. You need " + (ceil(GetPlayerArray().len()/2) - playerVotedNames.len()) + " more votes to skip.")
        if(true || playerVotedNames.find(player.GetPlayerName()) == -1){  // not voted yet //CHANGE
            playerVotedNames.append(player.GetPlayerName())
            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
				MessageToPlayer(GetPlayerArray()[i], eEventNotifications.PlayerWantsToSkip)
			}
        } 
        else {
            print("You already voted! Encourage others to vote with !skip")
        }
    }
    else{
        printl("Use this command in game!")
    }
    
    // check if enough have voted
    // change "half" in the if statement to whatever var or amount you want
    int half = ceil(1.0 * GetPlayerArray().len()/2).tointeger()
    int quater = ceil(1.0 * GetPlayerArray().len()/4).tointeger()
    int threeQuaters = ceil((1.0 * GetPlayerArray().len()/4)*3).tointeger()

    printl("len: " + playerVotedNames.len())
    if(playerVotedNames.len() >= 50){ //CHANGE
        //SetServerVar("gameEndTime", 1.0) // end this game //CHANGE
        playerVotedNames.clear()
    }

    return true
}
#endif
