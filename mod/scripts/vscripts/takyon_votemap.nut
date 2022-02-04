global function VoteMapInit

array<string> playerMapVoteNames = [] // list of players who have voted, is used to see how many have voted
bool voteMapEnabled = true
float mapTimeFrac = 0.5 // when the vote is displayed. 0.5 would be halftime
int howManyMapsToPropose = 5

struct MapVotesData{
    string mapName
    int votes
}

bool mapsHaveBeenProposed = false // dont fuck with this
array<string> maps = []
array<MapVotesData> voteData = []
array<string> proposedMaps = []
string nextMap = ""

void function VoteMapInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!vote", CommandVote) //!vote force 3 will force the map if your name is in adminNames
    AddClientCommandCallback("!VOTE", CommandVote)
    AddClientCommandCallback("!Vote", CommandVote)

    AddCallback_GameStateEnter(eGameState.Postmatch, Postmatch) // change map before the server changes it lololol

    // ConVar
    voteMapEnabled = GetConVarBool( "pv_vote_map_enabled" )
    string cvar = GetConVarString( "pv_maps" )
    mapTimeFrac = GetConVarFloat( "pv_map_time_frac" )

    maps = split( cvar, "," )
    foreach ( string map in maps )
        StringReplace( map, " ", "" )

    // loop to get time when map vote should be displayed
    thread Main()
}

/*
 *  COMMAND LOGIC
 */

void function Main(){
    if(!IsLobby()){
        while(voteMapEnabled && !mapsHaveBeenProposed){
            wait 10
            // check if halftime or whatever
            float endTime = expect float(GetServerVar("gameEndTime"))
            if(Time() / endTime >= mapTimeFrac && !mapsHaveBeenProposed){
                ProposeMaps()
            }
        }
    }
}

bool function CommandVote(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER TRIED VOTING")

        // check if voting is enabled
        if(!voteMapEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // check if the maps have been proposed
        if(!mapsHaveBeenProposed){
            SendHudMessageBuilder(player, MAPS_NOT_PROPOSED, 255, 200, 200)
            return false
        }

        if(args.len() < 1 || !IsInt(args[0])){
            SendHudMessageBuilder(player, MAP_VOTE_USAGE, 255, 200, 200)
            return false
        }

        /* admin gave map check
        if(args.len() == 1 && args[0] == "force"){
            SendHudMessageBuilder(player, MAP_NOT_GIVEN, 255, 200, 200)
            return false
        }*/

        if(args.len() == 2 && args[0] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
                return false
            }

            for(int i = 0; i < GetPlayerArray().len(); i++){
                SendHudMessageBuilder(GetPlayerArray()[i], ADMIN_VOTED_MAP, 255, 200, 200)
            }
            SetNextMap(args[1].tointeger(), true)
            return true
        }

        // check if player has already voted
        if(!PlayerHasVoted(player, playerMapVoteNames)){
            // add player to list of players who have voted
            playerMapVoteNames.append(player.GetPlayerName())
        }
        else {
            // Doesnt let the player vote twice, name is saved so even on reconnect they cannot vote twice
            // Future update might check if the player is actually online but right now i am too tired
            SendHudMessageBuilder(player, ALREADY_VOTED, 255, 200, 200)
            return false
        }
    }

    // check if num is valid
    int num = args[0].tointeger()
    if(num == 0 || num > proposedMaps.len()-1){
        SendHudMessageBuilder(player, MAP_NUMBER_NOT_FOUND, 255, 200, 200)
        return false
    }
    SetNextMap(num)
    return true
}

// post match logic

void function Postmatch(){
    thread ChangeMapBeforeServer()
}

void function ChangeMapBeforeServer(){
    wait GAME_POSTMATCH_LENGTH - 1 // change 1 sec before server does
    if(nextMap != "")
        GameRules_ChangeMap(nextMap, GameRules_GetGameMode())
    else
        GameRules_ChangeMap(maps[rndint(maps.len()-1)], GameRules_GetGameMode())
}

/*
 *  HELPER FUNCTIONS
 */

void function ProposeMaps(){
    string currMap = GetMapName()
    for(int i = 0; i < howManyMapsToPropose; i++){
        while(true){
            string temp = maps[rndint(howManyMapsToPropose - 1)]
            if(proposedMaps.find(temp) == -1){
                proposedMaps.append(temp)
                break
            }
        }
    }

    // create message
    string message = ""
    for (int i = 1; i <= proposedMaps.len(); i++) {
        message += i + ": " + proposedMaps[i-1] + "\n" // TODO make table and assign mapnames to their real name
    }

    // meesage all players
    foreach (entity player in GetPlayerArray()){
        SendHudMessage( player, message, -0.92, 0.5, 255, 255, 255, 255, 0.15, 30, 1 )
    }
    mapsHaveBeenProposed = true
}

void function SetNextMap(int num, bool force = false){
    int index = FindMvdInVoteData(proposedMaps[num-1])
    MapVotesData temp

    // is already in array
    if(index != -1){
        // increase votes
        temp = voteData[index]
        temp.votes = temp.votes + 1
    }
    else{ // add to array
        temp.votes = 1
        temp.mapName = proposedMaps[num-1]
        voteData.append(temp)
    }

    if(force){
        // set to unbeatable value // TODO bad fix but uhhh idc
        temp.votes = 1000
        return
    }

    voteData.sort(MapVotesSort)
    nextMap = voteData[0].mapName
}

int function FindMvdInVoteData(string mapName){ // returns -1 if not found
    int index = -1
    foreach(MapVotesData mvd in voteData){
        if(mvd.mapName == mapName)
            return index
        index++
    }
    return index
}

int function MapVotesSort(MapVotesData data1, MapVotesData data2)
{
  if ( data1.votes == data2.votes )
    return 0
  return data1.votes < data2.votes ? 1 : -1
}

bool function IsInt(string num){
    try {
        num.tointeger()
        return true
    } catch (exception){
        return false
    }
}