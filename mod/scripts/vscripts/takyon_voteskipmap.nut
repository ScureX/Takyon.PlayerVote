global function VoteSkipMapInit

array<string> adminNames = ["Takyon_Scure"] // list of usernames who should have admin privileges to execute commands like !rtv force

array<string> spawnedPlayers = []
int displayHintOnSpawnAmount = 2 // set this to the amount of spawns the hint to use !help should be displayed. 1 = only on dropship and first spawn, 2 on dropship, first and second spawn

array<string> playerSkipVoteNames = [] // list of players who have voted, is used to see how many have voted 

bool playerVoteKickEnabled = true // change this to false if you dont want users to be able to vote
array<string> playerKickVoteYesNames = []
array<string> playerKickVoteNoNames = []
string playerVotedForKick = ""


void function VoteSkipMapInit(){
    #if SERVER
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!skip", CommandSkip) //!skip force will change the map if your name is in adminNames
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)

    AddClientCommandCallback("!rtv", CommandSkip) // rock the vote. requested by @Hedelma
    AddClientCommandCallback("!RTV", CommandSkip)

    AddClientCommandCallback("!kick", CommandKick) // !kick playername force will kick a player if youre admin | normal kick: !kick playername
    AddClientCommandCallback("!yes", CommandYes)
    AddClientCommandCallback("!no", CommandNo)

    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)

    // admin commands
    // this will only work once i save shit like admin names in like a json file or sumn cause otherwise it will be reset on mapchange
    //AddClientCommandCallback("!admin", CommandHelp) // !admin add playername || !admin remove playernamepp

    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)
    #endif
}

#if SERVER
void function OnPlayerSpawned(entity player){
    // this prevents the message from being displayed every time someone spawns, which would be annoying. so we dont do that :)
    //printl("player spawned")
    int spawnAmount = 0
    foreach (name in spawnedPlayers)  {
        if (name == player.GetPlayerName())  {
            spawnAmount++
        }
    }   

    if(spawnedPlayers.find(player.GetPlayerName()) == -1 || spawnAmount <= displayHintOnSpawnAmount){
        printl("sent spawn message")
        SendHudMessageBuilder(player, "Open your console and type !help", 200, 200, 255)
        spawnedPlayers.append(player.GetPlayerName())
    }
}

void function OnPlayerDisconnected(entity player){
    // remove player from list so on reconnect they get the message again
    printl("player disconnected")
    spawnedPlayers.remove(spawnedPlayers.find(player.GetPlayerName()))
}

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

        if(!PlayerHasVoted(player, playerSkipVoteNames)){  // not voted yet 
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

        // player not on server
        bool playerInServer = false
        foreach(entity _player in GetPlayerArray()){ // shitty solution but cant do .find cause its not an entity
            if(_player.GetPlayerName() == args[0])
                playerInServer = true
        }

        if(!playerInServer){ 
            SendHudMessageBuilder(player, args[0] + " was not found", 255, 200, 200)
            return false
        }

        // admin kick
        if(args.len() == 2 && args[1] == "force"){
            // check for admin names
            if(adminNames.find(player.GetPlayerName()) != -1){
                ServerCommand("kick " + args[0]) 
                playerKickVoteYesNames.clear()
                SendHudMessageBuilder(player, "Kicked " + args[0], 255, 200, 200)
                return true
            }
            SendHudMessageBuilder(player, "Missing Privileges!", 255, 200, 200)
            return false
        }
        // starting the player vote
        if(playerKickVoteYesNames.len() == 0){ // no vote going yet
            // start vote by setting vars
            playerKickVoteYesNames.append(player.GetPlayerName())
            //playerKickVoteNoNames.append(args[0]) // change
            playerVotedForKick = args[0]

            // notify
            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], player.GetPlayerName() + " wants to kick " + args[0] + "\nTo vote type !yes or !no in your console", 255, 200, 200)
            }
            CheckIfEnoughKickVotes()
        }
        else{
            SendHudMessageBuilder(player, "There is already an active vote for " + args[0] + ".\nVote with !yes or !no", 255, 200, 200)
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

bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        SendHudMessageBuilder(player, "Use !skip or !rtv in your console to skip this map!", 200, 200, 255)
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function CheckIfEnoughKickVotes(){
    // 90% need to have voted and there need to be more yes than no votes
    if(playerKickVoteYesNames.len() > playerKickVoteNoNames.len() && (1.0 * playerKickVoteYesNames.len() + playerKickVoteNoNames.len()) > (GetPlayerArray().len() * 0.9)){ // CHANGE 0.9
        ServerCommand("kick " + playerVotedForKick)
        // notify
        for(int i = 0; i < GetPlayerArray().len(); i++){
            SendHudMessageBuilder(GetPlayerArray()[i], "Kicked " + playerVotedForKick, 255, 200, 200)
        }

        // clear vars
        playerKickVoteYesNames.clear()
        playerKickVoteNoNames.clear()
        playerVotedForKick = ""
    }
}

bool function PlayerHasVoted(entity player, array<string> arr){
    if(arr.find(player.GetPlayerName()) == -1){  // not voted yet 
        return false
    } 
    return true
}

void function AddPlayerKickVote(entity player, string votedPlayer){
    //if(GetPlayerArray().find(votedPlayer) != -1){ // player is on the server
        // TODO mabye this for havin multiple votes?
    //}
}

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

void function SendHudMessageBuilder(entity player, string message, int r, int g, int b){
    // SendHudMessage(player, message, x_pos, y_pos, R, G, B, A, fade_in_time, hold_time, fade_out_time)
    // Alpha doesnt work properly and is dependant on the RGB values for whatever fucking reason
    SendHudMessage( player, message, -1, 0.2, r, g, b, 255, 0.15, 6, 1 )
}

#endif