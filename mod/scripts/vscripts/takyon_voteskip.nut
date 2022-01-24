global function VoteSkipInit

array<string> playerSkipVoteNames = [] // list of players who have voted, is used to see how many have voted 

void function VoteSkipInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!skip", CommandSkip) //!skip force will change the map if your name is in adminNames
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)

    AddClientCommandCallback("!rtv", CommandSkip) // rock the vote. requested by @Hedelma
    AddClientCommandCallback("!RTV", CommandSkip)
    #endif
}

#if SERVER
/*
 *  COMMAND LOGIC
 */

bool function CommandSkip(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED VOTING")
        
        if(args.len() == 1 && args[0] == "force"){
            // check for admin names
            if(adminNames.find(player.GetPlayerName()) != -1){
                for(int i = 0; i < GetPlayerArray().len(); i++){
                    SendHudMessageBuilder(GetPlayerArray()[i], "Admin skipped", 255, 200, 200)
			    }
                CheckIfEnoughSkipVotes(true)
                return true
            }
            SendHudMessageBuilder(player, "Missing Privileges!", 255, 200, 200)
            return true
        }

        // check if player has already voted //TODO fix this up
        if(!PlayerHasVoted(player, playerSkipVoteNames)){
            // add player to list of players who have voted 
            playerSkipVoteNames.append(player.GetPlayerName())

            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                if(playerSkipVoteNames.len() > 1) // semantics
                    SendHudMessageBuilder(GetPlayerArray()[i], playerSkipVoteNames.len() + " Players Want To Skip This Map\nSkip this map by typing !skip in the console", 255, 200, 200)
                else
                    SendHudMessageBuilder(GetPlayerArray()[i], playerSkipVoteNames.len() + " Player Wants To Skip This Map\nSkip this map by typing !skip in the console", 255, 200, 200)
			}
        } 
        else {
            // Doesnt let the player vote twice, name is saved so even on reconnect they cannot vote twice
            // Future update might check if the player is actually online but right now i am too tired
            SendHudMessageBuilder(player, "You have already voted!", 255, 200, 200)
        }
    }
    CheckIfEnoughSkipVotes()
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function CheckIfEnoughSkipVotes(bool force = false){
    // check if enough have voted
    // change "half" in the if statement to whatever var or amount you want
    int half = ceil(1.0 * GetPlayerArray().len() / 2).tointeger()
    int quarter = ceil(1.0 * GetPlayerArray().len() / 4).tointeger() //fixed spelling, fuck you coopyy

    if(playerSkipVoteNames.len() >= half || force){ // CHANGE half
        SetServerVar("gameEndTime", 1.0) // end this game 
        playerSkipVoteNames.clear()
    }
}
#endif