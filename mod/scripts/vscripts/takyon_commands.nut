global function CommandsInit

global struct Command{
    array<string> names // allows for more variants like !sendrules and !sr being the same
    bool blockMessage // if chat message should be blocked, good for admin commands or anonymous votes
    string usage // this is for help
    bool functionref(entity, array<string>) func
}

global array<Command> commandArr

void function CommandsInit(){
    commandArr.append(new_CommandStruct(["skip", "rtv"], false, "", CommandSkip))
    commandArr.append(new_CommandStruct(["extend", "elongate", "ext"], false, "", CommandExtend)) // elongate is for Sye <3
    commandArr.append(new_CommandStruct(["kick"], false, "", CommandKick))
    commandArr.append(new_CommandStruct(["yes"], true, "", CommandYes))
    commandArr.append(new_CommandStruct(["no"], true, "", CommandNo))
    commandArr.append(new_CommandStruct(["switch"], false, "", CommandSwitch))
    commandArr.append(new_CommandStruct(["help"], false, "", CommandHelp))
    commandArr.append(new_CommandStruct(["ping"], true, "", CommandPing))
    commandArr.append(new_CommandStruct(["balance"], false, "", CommandBalance))
    commandArr.append(new_CommandStruct(["rules"], false, "", CommandRules))
    commandArr.append(new_CommandStruct(["sendrules", "sr"], true, "", CommandSendRules))
    commandArr.append(new_CommandStruct(["msg", "message"], true, "", CommandMsg))
    commandArr.append(new_CommandStruct(["announce", "ann"], true, "", CommandAnnounce))
    commandArr.append(new_CommandStruct(["vote"], false, "", CommandVote))
}

/*
 *  HELPER FUNCTIONS
 */

Command function new_CommandStruct(array<string> names, bool blockMessage, string usage, bool functionref(entity, array<string>) funkyFunc)
{
  Command newStruct
  newStruct.names = names
  newStruct.blockMessage = blockMessage
  newStruct.usage = usage
  newStruct.func = funkyFunc
  return newStruct
}