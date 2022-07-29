global function VoteKickInit
global function CommandKick
global function CommandYes
global function CommandNo
global function OnPlayerConnectedKick

bool playerVoteKickEnabled = true // change this to false if you dont want users/admins to be able to vote kick
float playerVotePercentage = 0.9 // percentage of how many people on the server need to have voted
array<string> playerKickVoteYesNames = []
array<string> playerKickVoteNoNames = []
string playerVotedForKick = ""
int minimumOnlinePlayers = 5 // minimum required players online to kick a person. this should be kept high cause if there are only 3, 2 people are enough to kick

bool saveKickedPlayers = true // true: kicked players cant rejoin the same match | false: kicked players can just rejoin
array<string> kickedPlayers = [] // kicked players are saved here. this will prevent them from rejoining the same match. kicked players are reset on mapchange!!!

void function VoteKickInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!kick", CommandKick) // !kick playername force will kick a player if youre admin | normal kick: !kick playername
    AddClientCommandCallback("!yes", CommandYes)
    AddClientCommandCallback("!no", CommandNo)

    // ConVars
    playerVoteKickEnabled = GetConVarBool( "pv_kick_enabled" )
    playerVotePercentage = GetConVarFloat( "pv_kick_percentage" )
    minimumOnlinePlayers = GetConVarInt( "pv_kick_min_players" )
    saveKickedPlayers = GetConVarBool( "pv_kick_save_players" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandKick(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED KICKING")
        
        // no player name given
        if(args.len() == 0){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_PLAYERNAME_FOUND, false)
            return false
        }

        // vote kick disabled
        if(!playerVoteKickEnabled){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + COMMAND_DISABLED, false)
            return false
        }

        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" +CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], false)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // players cannot kick themselves 
        if(fullPlayerName == player.GetPlayerName()){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + CANT_KICK_YOURSELF, false)
            return false
        }

        // admin kick
        if(args.len() >= 2 && args[1] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES, false)
                return false
            }
            
            ServerCommand("kick " + fullPlayerName) 
            playerKickVoteYesNames.clear()
            kickedPlayers.append(fullPlayerName)
            Chat_ServerPrivateMessage(player, "\x1b[38;2;0;128;0m" + KICKED_PLAYER + fullPlayerName, false)
            return true
        }

        // Check if enough people are online to initiate a vote
        if(GetPlayerArray().len() < minimumOnlinePlayers){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NOT_ENOUGH_PLAYERS_ONLINE_FOR_KICK, false)
            return false
        }

        if(playerKickVoteYesNames.len() == 0){ // no vote going yet
            // start vote by setting vars
            playerKickVoteYesNames.append(player.GetPlayerName())
            playerKickVoteNoNames.append(fullPlayerName) // CHANGE
            playerVotedForKick = fullPlayerName

            // notify
            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], player.GetPlayerName() + PLAYER_WANTS_TO_KICK_PLAYER + fullPlayerName + HOW_TO_KICK, 255, 200, 200)
            }
        }
        else{
            if(playerVotedForKick == fullPlayerName){
                CommandYes(player, [])
            }
            else{
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + ALREADY_VOTE_GOING + fullPlayerName + HOW_TO_KICK, false)
            }
        }
        CheckIfEnoughKickVotes()
    }
    return true
}

bool function CommandYes(entity player, array<string> args){
    if(playerVotedForKick == ""){
        Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_VOTE_GOING, false)
        return false
    }

    array<string> arr = playerKickVoteYesNames
    arr.extend(playerKickVoteNoNames)
    if(!PlayerHasVoted(player, arr)){
        playerKickVoteYesNames.append(player.GetPlayerName())
        CheckIfEnoughKickVotes()    
    }
    else{
        Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + ALREADY_VOTED, false)
    }
    return true
}

bool function CommandNo(entity player, array<string> args){
    if(playerVotedForKick == ""){
        Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_VOTE_GOING, false)
        return false
    }

    array<string> arr = playerKickVoteYesNames
    arr.extend(playerKickVoteNoNames)
    if(!PlayerHasVoted(player, arr)){
        playerKickVoteNoNames.append(player.GetPlayerName())
        CheckIfEnoughKickVotes()    
    }
    else{
        Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + ALREADY_VOTED, false)
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
            SendHudMessageBuilder(GetPlayerArray()[i], KICKED_PLAYER + playerVotedForKick, 255, 200, 200)
        }

        kickedPlayers.append(playerVotedForKick)
        // clear vars
        playerKickVoteYesNames.clear()
        playerKickVoteNoNames.clear()
        playerVotedForKick = ""
    }
}

void function OnPlayerConnectedKick(entity player){
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
