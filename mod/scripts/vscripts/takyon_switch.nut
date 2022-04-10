global function SwitchInit
global function CommandSwitch

bool switchEnabled = true // true: users can use !switch | false: users cant use !switch
bool adminSwitchPlayerEnabled = true // true: admins can switch users | false: admins cant switch users
int maxPlayerDiff = 1 // how many more players one team can have over the other.
int maxSwitches = 2 // how many times a player can switch teams per match. should be kept low so players cant spam to get an advantage

array<string> switchedPlayers = [] // array of players who have switched their team. does not include players switched by admin

void function SwitchInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!switch", CommandSwitch)
    AddClientCommandCallback("!SWITCH", CommandSwitch)
    AddClientCommandCallback("!Switch", CommandSwitch)

    // ConVars
    switchEnabled = GetConVarBool( "pv_switch_enabled" )
    adminSwitchPlayerEnabled = GetConVarBool( "pv_switch_admin_switch_enabled" )
    maxPlayerDiff = GetConVarInt( "pv_switch_max_player_diff" )
    maxSwitches = GetConVarInt( "pv_max_switches" )
}

/*
 *  COMMAND LOGIC
 */

bool function CommandSwitch(entity player, array<string> args){
    if(!IsLobby() && !IsFFAGame()){
        printl("USER USED SWITCH")

        // check if enabled
        if(!switchEnabled){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + COMMAND_DISABLED, false)
            return false
        }

        // no name or force given so it cant be an admin switch. -> switch player that requested
        if(args.len() < 1){
            // check if player has already switched too often
            if(FindAllSwitches(player) >= maxSwitches){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + SWITCHED_TOO_OFTEN, false)
                return false
            }

            switchedPlayers.append(player.GetPlayerName())
            SwitchPlayer(player)
            return true
        }

        // no player name given
        if(args.len() == 1){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_PLAYERNAME_FOUND, false)
            return false
        }

        // admin force switch
        if(args.len() >= 2 && args[0] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES, false)
                return false
            }

            // player not on server or substring unspecific
            if(!CanFindPlayerFromSubstring(args[1])){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + CANT_FIND_PLAYER_FROM_SUBSTRING + args[1], false)
                return false
            }

            // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
            string fullPlayerName = GetFullPlayerNameFromSubstring(args[1])

            // give player and admin feedback
            SendHudMessageBuilder(player, fullPlayerName + SWITCH_ADMIN_SUCCESS, 255, 200, 200)
            SendHudMessageBuilder(GetPlayerFromName(fullPlayerName), SWITCHED_BY_ADMIN, 255, 200, 200)
            SwitchPlayer(GetPlayerFromName(fullPlayerName), true)
        }
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function SwitchPlayer(entity player, bool force = false){
    int imcPlayerAmount = GetPlayerArrayOfTeam(TEAM_IMC).len()
    int militiaPlayerAmount = GetPlayerArrayOfTeam(TEAM_MILITIA).len()

    // switch from imc to militia
    if(player.GetTeam() == TEAM_IMC){
        printl("IMC: diff: " + (militiaPlayerAmount - imcPlayerAmount))
        // check if difference between team sizes is too big
        if(!CanPlayerSwitch(player, imcPlayerAmount, militiaPlayerAmount) && !force){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + SWITCH_TOO_MANY_PLAYERS, false)
            return
        }
        SetTeam(player, TEAM_MILITIA)
        SendHudMessageBuilder(player, SWITCH_SUCCESS, 200, 200, 255)
        return
    }

    // switch from militia to imc
    if(player.GetTeam() == TEAM_MILITIA){
        printl("MILIT: diff: " + (imcPlayerAmount - militiaPlayerAmount))
        // check if difference between team sizes is too big
        if(!CanPlayerSwitch(player, imcPlayerAmount, militiaPlayerAmount) && !force){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + SWITCH_TOO_MANY_PLAYERS, false)
            return
        }
        SetTeam(player, TEAM_IMC)
        SendHudMessageBuilder(player, SWITCH_SUCCESS, 200, 200, 255)
        return
    }

    // random on unassigned
    if(player.GetTeam() == TEAM_UNASSIGNED){
        array<int> teams = [TEAM_MILITIA, TEAM_IMC]

        SetTeam(player, teams[rndint(1)])
        Chat_ServerPrivateMessage(player, "\x1b[38;2;0;128;0m" + SWITCH_FROM_UNASSIGNED, false)
        return
    }
}

bool function CanPlayerSwitch(entity player, int imcPlayerAmount, int militiaPlayerAmount, bool force = false){
    if(player.GetTeam() == TEAM_IMC){
        if((militiaPlayerAmount - imcPlayerAmount) <= maxPlayerDiff){
            return true
        }
        return false
    }

    if(player.GetTeam() == TEAM_MILITIA){
        if((imcPlayerAmount - militiaPlayerAmount) <= maxPlayerDiff){
            return true
        }
        return false
    }

    if(player.GetTeam() == TEAM_UNASSIGNED){
        return true
    }
    return false
}

int function FindAllSwitches(entity player){
    int amount = 0
    foreach (string name in switchedPlayers){
        if(name == player.GetPlayerName())
            amount++
    }
    return amount
}
