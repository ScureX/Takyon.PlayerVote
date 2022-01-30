global function RulesInit

bool rulesEnabled = true // true: users can use !rules | false: users cant use !rules
bool adminSendRulesEnabled = true // true: admins can send users the rules | false: admins cant do that
int showRulesTime = 15 // for how many seconds the rules should be displayed when an admin sends them
string rules

void function RulesInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!rules", CommandRules)
    AddClientCommandCallback("!RULES", CommandRules)
    AddClientCommandCallback("!Rules", CommandRules)

    AddClientCommandCallback("!sendrules", CommandSendRules)
    AddClientCommandCallback("!sendRules", CommandSendRules)
    AddClientCommandCallback("!SENDRULES", CommandSendRules)
    AddClientCommandCallback("!sr", CommandSendRules)

    /*
     *  add rules here
     */

    // string rule99 = "this is your rule"
    string rule1 = "[1] Takyon is poggers"
    string rule2 = "[2] Someone didnt fill out their rules"
    string rule3 = "[3] chicken nugget"

    // add rules to the rule builder
    // dont forget the "\n" to add a new line, also dont put a + after the last rule
    rules = rule1 + "\n" +
            rule2 + "\n" + 
            rule3 + "\n"

    /*
     *  end of rules
     */
}

/*
 *  COMMAND LOGIC
 */

bool function CommandSendRules(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED SEND RULES")

        // send rules disabled
        if(!adminSendRulesEnabled){
            SendHudMessageBuilder(player, COMMAND_DISABLED, 255, 200, 200)
            return false
        }

        // Check if user is admin
        if(!IsPlayerAdmin(player)){
            SendHudMessageBuilder(player, MISSING_PRIVILEGES, 255, 200, 200)
            return false
        }

        // check if theres something after !announce
        if(args.len() < 1){
            SendHudMessageBuilder(player, NO_PLAYERNAME_FOUND + HOW_TO_SENDRULES, 255, 200, 200)
            return false
        }

        // check if player substring exists n stuff
        // player not on server or substring unspecific
        if(!CanFindPlayerFromSubstring(args[0])){
            SendHudMessageBuilder(player, CANT_FIND_PLAYER_FROM_SUBSTRING + args[0], 255, 200, 200)
            return false
        }

        // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
        string fullPlayerName = GetFullPlayerNameFromSubstring(args[0])

        // give admin feedback
        SendHudMessageBuilder(player, RULES_SENT_TO_PLAYER + fullPlayerName, 255, 200, 200)

        entity target = GetPlayerFromName(fullPlayerName)

        // last minute error handling if player cant be found
        if(target == null){
            SendHudMessageBuilder(player, PLAYER_IS_NULL, 255, 200, 200)
            return false
        }

        SendHudMessageBuilder(target, ADMIN_SENT_YOU_RULES + rules, 255, 200, 200)
    }
    return true
}

bool function CommandRules(entity player, array<string> args){
    if(!IsLobby()){
        printl("USER USED RULES")
        if(rulesEnabled)
            SendHudMessageBuilder(player, rules, 200, 200, 255, showRulesTime)
        else
            SendHudMessageBuilder(player, COMMAND_DISABLED, 200, 200, 255)
    }
    return true
}