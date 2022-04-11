// Since there cant be localization in a sever sided mod, this will sort of be one
// Here are all the basic strings
// Change these based on your servers language

// general
global const string ALREADY_VOTED = "You have already voted!"
global const string MISSING_PRIVILEGES = "Missing Privileges!"
global const string COMMAND_DISABLED = "This Command is disabled"
global const string NO_PLAYERNAME_FOUND = "No name given"
global const string CANT_FIND_PLAYER_FROM_SUBSTRING = "Couldn't match one player for " // remember the space at the end

// vote skip
global const string ADMIN_SKIPPED = "Admin skipped"
global const string MULTIPLE_SKIP_VOTES = " Players Want To Skip This Map\nSkip this map by typing !skip in chat" // remember to keep the space in the beginning
global const string ONE_SKIP_VOTE = " Player Wants To Skip This Map\nSkip this map by typing !skip in in chat" // remember to keep the space in the beginning

// announce
global const string NO_ANNOUNCEMENT_FOUND = "No message found\n!announce message"

// vote kick
global const string CANT_KICK_YOURSELF = "You cannot kick yourself"
global const string KICKED_PLAYER = "Kicked " // remember the space at the end
global const string NOT_ENOUGH_PLAYERS_ONLINE_FOR_KICK = "Not enough players online to votekick"
global const string PLAYER_WANTS_TO_KICK_PLAYER = " wants to kick " // remember to keep the space in the beginning and at the end
global const string HOW_TO_KICK = "\nTo vote type !yes or !no in chat (anonymous)"
global const string ALREADY_VOTE_GOING = "There is already an active vote for " // remember the space at the end
global const string NO_VOTE_GOING = "There is no vote going on. Use !kick"

// message
global const string HOW_TO_MESSAGE = "\n!msg playerName message"
global const string NO_MESSAGE_FOUND = "No message found"
global const string PLAYER_IS_NULL = "There was an error. The player might've left"
global const string MESSAGE_SENT_TO_PLAYER = "Message sent to " // remember the space at the end

// help
global const string HELP_MESSAGE = "Welcome to Karma Kraber9k! Type !help in chat"

// vote extend
global const string ADMIN_EXTENDED = "Admin extended map time"
global const string MAP_CANT_BE_EXTENDED_TWICE = "The map cannot be extended twice"
global const string MULTIPLE_EXTEND_VOTES = " Players Want To Play This Map Longer\nExtend this map by typing !extend in in chat" // remember to keep the space in the beginning
global const string ONE_EXTEND_VOTE = " Player Wants To Play This Map Longer\nExtend this map by typing !extend in in chat" // remember to keep the space in the beginning
global const string MAP_EXTENDED = "Map has been extended!"

// rules
global const string HOW_TO_SENDRULES = "\n!sr playerName"
global const string RULES_SENT_TO_PLAYER = "Rules sent to " // remember the space at the end
global const string ADMIN_SENT_YOU_RULES = "An Admin has decided that you should read the rules!\n\n" // two linebreaks to distinguish from rules

// switch
global const string SWITCH_FROM_UNASSIGNED = "You were unassigned so a random team has been chosen"
global const string SWITCH_TOO_MANY_PLAYERS = "There are too many players on the enemy team"
global const string SWITCHED_BY_ADMIN = "Your team has been switched by an admin"
global const string SWITCHED_TOO_OFTEN = "You have switched too often. You can switch teams again next map"
global const string SWITCH_ADMIN_SUCCESS = " has been switched" // message for admin that player has been switched. remember to keep the space in the beginning
global const string SWITCH_SUCCESS = "You have switched teams" // message for player that they have switched

// balance
global const string BALANCED = "Teams have been balanced by K/D"
global const string ONE_BALANCE_VOTE = " Player Wants To Balance The Teams by K/D\nBalance teams by typing !balance in in chat" // remember to keep the space in the beginning
global const string MULTIPLE_BALANCD_VOTES = " Players Want To Balance The Teams by K/D\nBalance teams by typing !balance in in chat" // remember to keep the space in the beginning
global const string ADMIN_BALANCED = "An Admin has balanced the teams by K/D"

// map vote
global const string MAPS_NOT_PROPOSED = "Maps have not been proposed yet"
global const string MAP_VOTE_USAGE = "!vote number -> in chat"
global const string ADMIN_VOTED_MAP = "Admin set the next map to "
global const string MAP_NOT_GIVEN = "No map given"
global const string MAP_NUMBER_NOT_FOUND = "Map number not found"
global const string MAP_YOU_VOTED = "You have voted for " // remember the space at the end
global const string MAP_VOTE_USAGE_PROPOSED = "To vote type !vote number in chat. \x1b[38;2;0;220;220m(Ex. !vote 2)"
