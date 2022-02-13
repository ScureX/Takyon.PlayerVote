global function HelpInit

string version = "v3.0.1"
bool helpEnabled = true
int displayHintOnSpawnAmount = 0
bool useGeneratedHelp = true // will auto-generate text for the help command. set false if you want to input your own help text

array<string> spawnedPlayers = []
array<string> cmdArr = []

string commands =   "[ !skip, !extend, !kick, !rules, !switch, !balance, !ping, !vote ]"
string skip =       "[ !skip        -> to skip the map                  ]"
string extend =     "[ !extend      -> to play this map longer          ]"
string kick =       "[ !kick        -> to kick a player                 ]"
string switchcmd =  "[ !switch      -> to switch teams                  ]"
string ping =       "[ !ping (name) -> get your or a player's ping      ]"
string balance =    "[ !balance     -> vote to balance teams by kd      ]"
string rules =      "[ !rules       -> get the server's rules           ]"
string message =    "[ !msg         -> !msg player message              ]"
string announce =   "[ !announce    -> !announce message                ]"
string vote =       "[ !vote        -> !vote number                     ]"

// dont forget to add new strings in cmdArr in InitCommands()
void function InitCommands(){
    cmdArr.append(commands)
    cmdArr.append(skip)
    cmdArr.append(extend)
    cmdArr.append(kick)
    cmdArr.append(switchcmd)
    cmdArr.append(ping)
    cmdArr.append(balance)
    cmdArr.append(rules)
    cmdArr.append(message)
    cmdArr.append(announce)
    cmdArr.append(vote)
}

void function HelpInit(){
    // add commands
    InitCommands()

    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!help", CommandHelp)
    AddClientCommandCallback("!HELP", CommandHelp)
    AddClientCommandCallback("!Help", CommandHelp)

    // More or less only relevant for me to see what verison servers are on without contacting the owner
    AddClientCommandCallback("!version", CommandVersion)

    // callbacks
    AddCallback_OnPlayerRespawned(OnPlayerSpawned)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)

    // ConVar
    helpEnabled = GetConVarBool( "pv_help_enabled" )
    displayHintOnSpawnAmount = GetConVarInt( "pv_display_hint_on_spawn_amount" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandHelp(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED HELP")
        if(!helpEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        if(args.len() > 0){
            switch (args[0]) {
                case "skip":
                    SendHudMessageBuilder(player, skip, 200, 200, 255)
                    break;
                case "extend":
                    SendHudMessageBuilder(player, extend, 200, 200, 255)
                    break;
                case "kick":
                    SendHudMessageBuilder(player, kick, 200, 200, 255)
                    break;
                case "switch":
                    SendHudMessageBuilder(player, switchcmd, 200, 200, 255)
                    break;
                case "ping":
                    SendHudMessageBuilder(player, ping, 200, 200, 255)
                    break;
                case "balance":
                    SendHudMessageBuilder(player, balance, 200, 200, 255)
                    break;
                case "rules":
                    SendHudMessageBuilder(player, rules, 200, 200, 255)
                    break;
                case "msg":
                    SendHudMessageBuilder(player, message, 200, 200, 255)
                    break;
                case "announce":
                    SendHudMessageBuilder(player, announce, 200, 200, 255)
                    break;
                case "vote":
                    SendHudMessageBuilder(player, vote, 200, 200, 255)
                    break;
                default:
                    SendHudMessageBuilder(player, commands, 200, 200, 255)
                    break;
                return true
            }
        }
        SendHudMessageBuilder(player, commands, 200, 200, 255)
    }
    return true
}
bool function CommandVersion(entity player, array<string> args){
    if(!IsLobby()){
        SendHudMessageBuilder(player, version, 200, 200, 255)
        return true
    }
    return false
}

/*
 *  HELP HINT MESSAGE LOGIC
 */

void function OnPlayerSpawned(entity player){
    // this prevents the message from being displayed every time someone spawns, which would be annoying. so we dont do that :)
    int spawnAmount = 0
    foreach (name in spawnedPlayers)  {
        if (name == player.GetPlayerName())  {
            spawnAmount++
        }
    }

    bool shouldWelcome = welcomeEnabled && spawnAmount == 0
    bool shouldDisplayHelp = spawnAmount <= displayHintOnSpawnAmount
    bool enoughTimeAfterMapProposal = Time() - mapsProposalTimeLeft > 10

    if(shouldWelcome && !mapsHaveBeenProposed){
        ShowWelcomeMessage(player)
    }
    else if(shouldDisplayHelp && (!mapsHaveBeenProposed || (enoughTimeAfterMapProposal && spawnAmount > 0))){
        SendHudMessageBuilder(player, HELP_MESSAGE, 200, 200, 255) // Message that gets displayed on respawn
    }
    spawnedPlayers.append(player.GetPlayerName()) 
}

void function OnPlayerDisconnected(entity player){
    // remove player from list so on reconnect they get the message again
    while(spawnedPlayers.find(player.GetPlayerName()) != -1){
        try{
            spawnedPlayers.remove(spawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling
    }
}