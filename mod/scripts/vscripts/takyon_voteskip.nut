global function VoteSkipInit
global function CommandSkip
global function CommandSkipCall

array<string> playerSkipVoteNames = [] // list of players who have voted, is used to see how many have voted
float skipVotePercentage = 0.8 // percentage of how many people on the server need to have voted
bool skipEnabled = true

void function VoteSkipInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!skip", CommandSkip) //!skip force will change the map if your name is in adminNames
    AddClientCommandCallback("!SKIP", CommandSkip)
    AddClientCommandCallback("!Skip", CommandSkip)

    AddClientCommandCallback("!rtv", CommandSkip) // rock the vote. requested by @Hedelma
    AddClientCommandCallback("!RTV", CommandSkip)

    // ConVar
    skipEnabled = GetConVarBool( "pv_skip_enabled" )
    skipVotePercentage = GetConVarFloat( "pv_skip_percentage" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandSkipCall(entity player = null, array<string> args = []){
    return true
}

bool function CommandSkip(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED SKIPPING")

        if(args.len() == 1 && args[0] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES,false)
                return false
            }

            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], ADMIN_SKIPPED, 255, 200, 200)
            }
            CheckIfEnoughSkipVotes(true)
            return true
        }

        // check if skipping is enabled
        if(!skipEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // check if player has already voted //TODO fix this up
        if(!PlayerHasVoted(player, playerSkipVoteNames)){
            // add player to list of players who have voted
            playerSkipVoteNames.append(player.GetPlayerName())

            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                if(playerSkipVoteNames.len() > 1) // semantics
                    SendHudMessageBuilder(GetPlayerArray()[i], playerSkipVoteNames.len() + MULTIPLE_SKIP_VOTES, 255, 200, 200)
                else
                    SendHudMessageBuilder(GetPlayerArray()[i], playerSkipVoteNames.len() + ONE_SKIP_VOTE, 255, 200, 200)
			}
        }
        else {
            // Doesnt let the player vote twice, name is saved so even on reconnect they cannot vote twice
            // Future update might check if the player is actually online but right now i am too tired
            SendHudMessageBuilder(player, ALREADY_VOTED, 255, 200, 200)
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
    if(playerSkipVoteNames.len() >= (1.0 * GetPlayerArray().len() * skipVotePercentage) || force){
        if(mapsHaveBeenProposed){
            PVSetGameEndTime(1.0)}
        else{
            FillProposedMaps()
            PVSetGameEndTime(30.0)
        }
    }
}

void function PVSetGameEndTime(float seconds){
    if (IsRoundBased()) {
      float roundEndTime = Time() - expect float(GetServerVar("roundEndTime"));
      if (roundEndTime > seconds) seconds = roundEndTime; // If there's less time in the round left than we request, don't increase
      SetRoundEndTime(seconds); // Set round end timer - for aesthetics only
      thread PostmatchMap_Threaded(seconds);
    }
    else {
      SetGameEndTime(seconds);
    }

    playerSkipVoteNames.clear()
}

/* Helper function to change the map on round based game gamemodes
*/
void function PostmatchMap_Threaded(float seconds) {
  wait seconds + 2.0; // Wait a couple seconds for fade effect
  if (IsSuddenDeathGameMode()) PostmatchMap(); // Going to postmatch does not work on SD modes e.g. ctf - It will just go to half time then SD
  else SetGameState( eGameState.Postmatch )
}
