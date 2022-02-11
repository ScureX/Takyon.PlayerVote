# PlayerVote

Enables players to vote on different things like skipping a map or kicking a player, to add a true community feeling to your server! Also includes admin functionalities to enforce some rules.  
> **BIG THANKS to: Elmo, Alt4, Coopyy, Spoon, Dullahan, Tsk22, wolf109909, Pandora and all the other people that helped me through this nightmare of a project! <3**

**Consider supporting this project on [ko-fi](https://ko-fi.com/takyon_scure)**

---

# Contributing
The main branch is only updated with minor changes between releases! The newest features are always in a seperate branch and will be merged with main on release. Versioned branches might have bugs or other issues till release. Once released they should be fully functional and will be merged with main.

## How to contribute
[Here](https://github.com/ScureX/Takyon.PlayerVote/projects/1) you can see planned features/bugs and their current status. 

> ### Contribute Code
> The main branch will always work so it's safe to implement stuff on top of it, it will be merged with a versioned branch and then released. You could also build features on versioned branches, however this might result in more merge conflicts.

> ### Contribute Ideas
> You can open a [Discussion](https://github.com/ScureX/Takyon.PlayerVote/discussions/categories/ideas) and share your thoughts on certain features, suggest improvements or new features. You can also DM me on Discord: ```Takyon Scure#6969```

---

# Commands
## !help
Shows the player who requested it a hint, telling them to type !skip in their console if they want to skip this map

## !skip | !rtv
### Usage: [!skip]  [!skip force] | [!rtv]  [!rtv force]
This lets the player vote to skip the map. It sends a message to everyone showing how many people want to skip and that they can skip with !skip. If half the Players voted to skip, the game time will be set to 1 second, allowing stats to be seen and switching to a new map.

Users cannot vote twice as their name is being tracked. They will get a message that they have already voted.  

Votes are reset on map change.

!skip force only works for people declared as admins in the andminNames array. This lets them skip without voting.

## !kick
### Usage: [!kick name]  [!kick name force] | [!yes]  [!no]

Lets people vote on kicking a player by typing !yes or !no. By default at least 90% of people need to have voted and more than half of those have to vote for kicking. (This can be changed)

Not the full name has to be given, just enough to identify a player.

!kick name force only works for people declared as admins in the andminNames array. This lets them kick without voting.

This feature can be disabled, even disallowing admins to kick.

There cannot be two votes at the same time. Mabye adding a time limit in the future?

## !extend
### Usage: [!extend]  [!extend force]

Lets people vote on extending the map to play longer. (The time added can be changed)

By default the map can only be extended once. (This can be changed)

Force can only be used by admins, and will always extend the map.

## !rules
### Usage: [!rules]
Shows the user the servers rules, specified in ```takyon_rules.nut```. Change or disable these!

## !sendrules |!sr
### Usage: [!sendrules]  [!sr]
Lets an admin send the rules to a specific user. Rules are shown for longer and have a notice that an admin sent these. This can be used on users who misbehave.

## !msg
### Usage: [!msg playerName message]
Lets an admin send an anonymous direct message to the player. This might help with toxic users or if you do not want to embarrass them publicly, which may lead to more problems.

Not the full name has to be given, just enough to identify a player.

## !announce
### Usage: [!announce message]
Lets an admin announce something. The message is displayed for everyone. 

## !switch
### Usage: [!switch]  [!switch force player]
Lets a player switch teams based on some rules to keep the match balanced.  
Lets an admin switch the team of a player.

## !balance
### Usage: [!balance]  [!balance force]
Lets players vote on balancing the teams based on K/D.  
This will distribute good players evenly to make a fair match.

## !vote
### Usage: [!vote]  [!vote number]  [!vote number force]
Lets players vote which map will be played next.  
Also lets the server hoster make a custom map playlist with every available map regardless of gamemode.  


---

# Settings
This mod can be configured using the following [ConVars](https://r2northstar.gitbook.io/r2northstar-wiki/hosting-a-server-with-northstar/dedicated-server#convars), which can be set inside your `R2Northstar\mods\Northstar.CustomServers\mod\cfg\autoexec_ns_server.cfg` file:

| Name                              | Description                                                                                                                         | Default value    | Accepted Value |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------   | ---------------- | -------------- |
| `pv_admin_uids`                   | Comma-separated list of player's UIDs who should be able to force votes like kick, skip and extend                                  | `"1006880507304"`| `string`       |
| `pv_display_hint_on_spawn_amount` | Amount of times (after dropship) a hint to type !help should be displayed on respawn. Always displayed in dropship unless set to -1 | `2`              | `int`          |
| `pv_help_enabled`                 | Allow players to use !help                                                                                                          | `1`              | `0-1`          |
| `pv_skip_enabled`                 | Allow players to start a voteskip                                                                                                   | `1`              | `0-1`          |
| `pv_skip_percentage`              | Percentage of "skip" votes required for a vote to pass                                                                              | `0.8`            | `float`        |
| `pv_kick_enabled`                 | Allow players to start a votekick                                                                                                   | `1`              | `0-1`          |
| `pv_kick_percentage`              | Percentage of "yes" required for a vote to pass                                                                                     | `0.9`            | `float`        |
| `pv_kick_min_players`             | How many people have to be online for a votekick to be initiated so that when 3 people are online 2 cant kick 1. Avoids trolling.   | `5`              | `int`          |
| `pv_extend_vote_enabled`          | Allow players to start a vote extend                                                                                                | `1`              | `0-1`          |
| `pv_extend_percentage`            | Percentage of "extend" votes required for a vote to pass                                                                            | `0.6`            | `float`        |
| `pv_extend_map_multiple_times`    | Allow multiple extensions of the same map                                                                                           | `0`              | `0-1`          |
| `pv_extend_amount`                | By how many minutes the map gets extended on vote passed                                                                            | `3.5`            | `float`        |
| `pv_rules_enabled`                | Allow !rule usage                                                                                                                   | `1`              | `0-1`          |
| `pv_rules_admin_send_enabled`     | Allow admins to send users the rules                                                                                                | `1`              | `0-1`          |
| `pv_rules_show_time`              | For how many seconds the rules should be displayed when an admin sends them                                                         | `15`             | `int`          |
| `pv_message`                      | Admins can send players messages                                                                                                    | `1`              | `0-1`          |
| `pv_announce`                     | Admins can make announcements                                                                                                       | `1`              | `0-1`          |
| `pv_switch_enabled`               | Allows players to use !switch to switch teams                                                                                     | `1`              | `0-1`          |
| `pv_switch_admin_switch_enabled`  | Allows admins to use !switch force name to switch a player                                                                        | `1`              | `0-1`          |
| `pv_switch_max_player_diff`       | How many more players the enemy team can have. If they have more than this value, a player cant !switch                           | `1`              | `int`          |
| `pv_max_switches`                 | How many times a player can !switch per match. Keep this low to prevent abuse as there is no timer                                | `2`              | `int`          |

# Adding rules
Rules can be added in `mod\scripts\vscripts\takyon_rules.nut` below the "add rules here" section.

To make a new Rule add this below the other rules:

```string rule99 = "[99] this is a rule"```

Make sure it's getting diplayed by adding it to "rules". Add a ```+``` behind the last ```\n``` then add your rule with:

```rule99 + "\n"```
