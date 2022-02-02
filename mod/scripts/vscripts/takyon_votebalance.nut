global function BalanceInit

bool balanceEnabled = true
float balanceVotePercentage = 0.5 // percentage of how many people on the server need to have voted
array<string> playerBalanceVoteNames = [] // list of players who have voted, is used to see how many have voted

void function BalanceInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!balance", CommandBalance)
    AddClientCommandCallback("!BALANCE", CommandBalance)
    AddClientCommandCallback("!Balance", CommandBalance)

    // ConVar
    balanceEnabled = GetConVarBool( "pv_balance_enabled" )
    balanceVotePercentage = GetConVarFloat( "pv_balance_percentage" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandBalance(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED BALANCE")
        if(!balanceEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // admin force vote
        if(args.len() == 1 && args[0] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
                return false
            }

            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], ADMIN_BALANCED, 255, 200, 200)
                CheckIfEnoughBalanceVotes(true)
            }
            return true
        }

        // check if player has already voted
        if(!PlayerHasVoted(player, playerBalanceVoteNames)){
            // add player to list of players who have voted
            playerExtendVoteNames.append(player.GetPlayerName())

            // send message to everyone
            for(int i = 0; i < GetPlayerArray().len(); i++){
                if(playerExtendVoteNames.len() > 1) // semantics
                    SendHudMessageBuilder(GetPlayerArray()[i], playerExtendVoteNames.len() + MULTIPLE_BALANCD_VOTES, 255, 200, 200)
                else
                    SendHudMessageBuilder(GetPlayerArray()[i], playerExtendVoteNames.len() + ONE_BALANCE_VOTE, 255, 200, 200)
			}
        }
        else {
            // Doesnt let the player vote twice, name is saved so even on reconnect they cannot vote twice
            // Future update might check if the player is actually online but right now i am too tired
            SendHudMessageBuilder(player, ALREADY_VOTED, 255, 200, 200)
        }
    }
    CheckIfEnoughBalanceVotes()
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function CheckIfEnoughBalanceVotes(bool force = false){
    // check if enough have voted if it wasn't forced to begin with
    if(playerBalanceVoteNames.len() >= (1.0 * GetPlayerArray().len() * balanceVotePercentage) || force) {
        Balance()
        // message everyone
        for(int i = 0; i < GetPlayerArray().len(); i++){
            SendHudMessageBuilder(GetPlayerArray()[i], BALANCED, 255, 200, 200)
        }
        playerBalanceVoteNames.clear()
    }
}

void function Balance(){
    // sort players based on kd
    array<entity> playerRanks = GetPlayersSortedBySkill(GetPlayerArray())

    for(int i = 0; i < GetPlayerArray().len(); i++){
        if(IsEven(i)){
            SetTeam(playerRanks[i], TEAM_IMC)
        }
        else{
            SetTeam(playerRanks[i], TEAM_MILITIA)
        }
    }
}

array<entity> function GetPlayersSortedBySkill(array<entity> arr){
    foreach (entity player in arr) {
        // get kd for player
        float kd = player.GetPlayerGameStat(PGS_KILLS) / player.GetPlayerGameStat(PGS_DEATHS)
        var table[kd] <- player
    }
    return table.sort()
}

bool function IsEven(int i){
    return (i % 2) = 0
}