global function CommandsInit

global struct Command{
    array<string> names // allows for more variants like !sendrules and !sr being the same
    bool blockMessage // if chat message should be blocked, good for admin commands or anonymous votes
    string usage // this is for help
    bool functionref(entity, array<string>) func
}

global array<Command> commandArr

void function CommandsInit(){
    commandArr.append(new_CommandStruct(["skip", "rtv"],                false, "!skip -> to skip the map", CommandSkip))
    commandArr.append(new_CommandStruct(["extend", "elongate", "embiggen", "makethemaptimelonger", "unfinish", "ext"],  false, "!extend -> to play this map longer", CommandExtend)) // elongate is for Sye <3
    commandArr.append(new_CommandStruct(["kick"],                       false, "!kick -> to kick a player", CommandKick))
    commandArr.append(new_CommandStruct(["yes"],                        true, "!yes -> vote to kick a player", CommandYes))
    commandArr.append(new_CommandStruct(["no"],                         true, "!no -> vote to not kick a player", CommandNo))
    commandArr.append(new_CommandStruct(["switch"],                     false, "!switch -> to switch teams", CommandSwitch))
    commandArr.append(new_CommandStruct(["help"],                       false, "", CommandHelp))
    commandArr.append(new_CommandStruct(["discord", "dc"],              false, "!discord -> to display the link to the discord server", CommandDiscord))
    commandArr.append(new_CommandStruct(["getuid", "gu"],               true, "!getuid name -> get the UID of a player", CommandGetUid))
    commandArr.append(new_CommandStruct(["ping"],                       true, "!ping (name) -> get your or a player's ping", CommandPing))
    commandArr.append(new_CommandStruct(["balance", "bal"],             false, "!balance -> vote to balance teams by kd", CommandBalance))
    commandArr.append(new_CommandStruct(["rules"],                      false, "!rules -> get the server's rules", CommandRules))
    commandArr.append(new_CommandStruct(["sendrules", "sr"],            true, "!sr -> send the rules to a player", CommandSendRules))
    commandArr.append(new_CommandStruct(["msg", "message"],             true, "!msg -> !msg player message", CommandMsg))
    commandArr.append(new_CommandStruct(["announce", "ann"],            true, "!announce -> !announce message", CommandAnnounce))
    commandArr.append(new_CommandStruct(["vote", "maps"],               false, "!vote -> !vote [number] to vote for the next map", CommandVote))
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