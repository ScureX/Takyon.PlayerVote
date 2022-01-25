global function VoteKickInit

bool playerVoteKickEnabled = true // change this to false if you dont want users/admins to be able to vote kick
float playerVotePercentage = 0.9 // CHANGE 0.9
array<string> playerKickVoteYesNames = []
array<string> playerKickVoteNoNames = []
string playerVotedForKick = ""
int minimumOnlinePlayers = 5 // minimum required players online to kick a person. this should be kept high cause if there are only 3, 2 people are enough to kick

bool saveKickedPlayers = true // true: kicked players cant rejoin the same match | false: kicked players can just rejoin
array<string> kickedPlayers = [] // kicked players are saved here. this will prevent them from rejoining the same match. kicked players are reset on mapchange!!!

void function VoteKickInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!kick", CommandKick) // !kick playername force will kick a player if youre admin | normal kick: !kick playername
    AddClientCommandCallback("!yes", CommandYes)
    AddClientCommandCallback("!no", CommandNo)

    AddCallback_OnClientConnected(OnPlayerConnected)
    #endif
}

#if SERVER
/*
 *  COMMAND LOGIC
 */

bool function CommandKick(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED KICKING")
        
        // no player name given
        if(args.len() == 0){
            SendHudMessageBuilder(player, "No name given", 255, 200, 200)
            return false
        }

        // vote kick disabled
        if(!playerVoteKickEnabled){
            SendHudMessageBuilder(player, "Votekick is disabled", 255, 200, 200)
            return false
        }

        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            SendHudMessageBuilder(player, "Couldn't match one player for " + args[0], 255, 200, 200)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // players cannot kick themselves 
        if(fullPlayerName == player.GetPlayerName()){
            SendHudMessageBuilder(player, "You cannot kick yourself", 255, 200, 200)
            return false
        }

        // admin kick
        if(args.len() == 2 && args[1] == "force"){
            // check for admin names
            if(adminNames.find(player.GetPlayerName()) != -1){
                ServerCommand("kick " + fullPlayerName) 
                playerKickVoteYesNames.clear()
                SendHudMessageBuilder(player, "Kicked " + fullPlayerName, 255, 200, 200)
                return true
            }
            SendHudMessageBuilder(player, "Missing Privileges!", 255, 200, 200)
            return false
        }

        // Check if enough people are online to initiate a vote
        if(GetPlayerArray().len() < minimumOnlinePlayers){
            SendHudMessageBuilder(player, "Not enough players online to votekick", 255, 200, 200)
            return false
        }

        // starting the player vote
        if(playerKickVoteYesNames.len() == 0){ // no vote going yet
            // start vote by setting vars
            playerKickVoteYesNames.append(player.GetPlayerName())
            playerKickVoteNoNames.append(fullPlayerName) // CHANGE
            playerVotedForKick = fullPlayerName

            // notify
            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], player.GetPlayerName() + " wants to kick " + fullPlayerName + "\nTo vote type !yes or !no in your console", 255, 200, 200)
            }
            CheckIfEnoughKickVotes()
        }
        else{
            SendHudMessageBuilder(player, "There is already an active vote for " + fullPlayerName + ".\nVote with !yes or !no", 255, 200, 200)
        }
    }
    return true
}

bool function CommandYes(entity player, array<string> args){
    if(playerVotedForKick == ""){
        SendHudMessageBuilder(player, "There is no vote going on. Use !kick", 255, 200, 200)
        return false
    }

    array<string> arr = playerKickVoteYesNames
    arr.extend(playerKickVoteNoNames)
    if(!PlayerHasVoted(player, arr)){
        playerKickVoteYesNames.append(player.GetPlayerName())
        CheckIfEnoughKickVotes()    
    }
    else{
        SendHudMessageBuilder(player, "You have already voted", 255, 200, 200)
    }
    return true
}

bool function CommandNo(entity player, array<string> args){
    if(playerVotedForKick == ""){
        SendHudMessageBuilder(player, "There is no vote going on. Use !kick", 255, 200, 200)
        return false
    }

    array<string> arr = playerKickVoteYesNames
    arr.extend(playerKickVoteNoNames)
    if(!PlayerHasVoted(player, arr)){
        playerKickVoteNoNames.append(player.GetPlayerName())
        CheckIfEnoughKickVotes()    
    }
    else{
        SendHudMessageBuilder(player, "You have already voted", 255, 200, 200)
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function CheckIfEnoughKickVotes(){
    // 90% need to have voted and there need to be more yes than no votes
    bool moreYesThanNo = playerKickVoteYesNames.len() > playerKickVoteNoNames.len()
    bool enoughPeopleVoted = (1.0 * playerKickVoteYesNames.len() + playerKickVoteNoNames.len()) > (GetPlayerArray().len() * playerVotePercentage)
    if(moreYesThanNo && enoughPeopleVoted){ 
        // check if player is still in server

        ServerCommand("kick " + playerVotedForKick)
        // notify
        for(int i = 0; i < GetPlayerArray().len(); i++){
            SendHudMessageBuilder(GetPlayerArray()[i], "Kicked " + playerVotedForKick, 255, 200, 200)
        }

        kickedPlayers.append(playerVotedForKick)
        // clear vars
        playerKickVoteYesNames.clear()
        playerKickVoteNoNames.clear()
        playerVotedForKick = ""
    }
}

void function OnPlayerConnected(entity player){
    // check if connected player got kicked this game 
    if(saveKickedPlayers)
        if(kickedPlayers.find(player.GetPlayerName()) != -1) // if player is in kickedPlayers
            ServerCommand("kick " + player.GetPlayerName())
}

/*void function AddPlayerKickVote(entity player, string votedPlayer){
    //if(GetPlayerArray().find(votedPlayer) != -1){ // player is on the server
        // TODO mabye this for havin multiple votes?
    //}
}*/
#endif