# PlayerVote

Enables players to vote on different things like skipping a map or kicking a player, to add a true community feeling to your server! Also includes admin functionalities to enforce some rules.

BIG THANKS to: Coopyy, Spoon, Dullahan, Tsk22, wolf109909, Pandora and all the other people that helped me through this nightmare of a project! <3

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

---

# Settings
This mod can be configured using the following ConVars:

| Name                              | Description                                                                                                                       | Default value    | Accepted Value |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------- | -------------- |
| `pv_admin_names`                  | Comma-separated of players who should be able to force votes like kick, skip and extend                                           | `"TakyonSecure"` | `string`       |
| `pv_display_hint_on_spawn_amount` | Amount of times (after dropship) a hint to type !help should be displayed on respawn                                              | `2`              | `int`          |
| `pv_skip_enabled`                 | Allow players to start a voteskip                                                                                                 | `1`              | `0-1`          |
| `pv_kick_enabled`                 | Allow players to start a votekick                                                                                                 | `1`              | `0-1`          |
| `pv_kick_percentage`              | Percentage of "yes" required for a vote to pass                                                                                   | `0.9`            | `float`        |
| `pv_kick_min_players`             | How many people have to be online for a votekick to be initiated so that when 3 people are online 2 cant kick 1. Avoids trolling. | `5`              | `int`          |
| `pv_extend_map_multiple_times`    | Allow multiple extensions of the same map                                                                                         | `0`              | `0-1`          |
| `pv_extend_amount`                | By how many minutes the map gets extended on vote passed                                                                          | `3.5`            | `float`        |
| `pv_rules_enabled`                | Allow !rule usage                                                                                                                 | `1`              | `0-1`          |
| `pv_rules_admin_send_enabled`     | Allow admins to send users the rules                                                                                              | `1`              | `0-1`          |
| `pv_rules_show_time`              | For how many seconds the rules should be displayed when an admin sends them                                                       | `15`             | `int`          |
| `pv_message`                      | Admins can send players messages                                                                                                  | `1`              | `0-1`          |
| `pv_announce`                     | Admins can make announcements                                                                                                     | `1`              | `0-1`          |

# Adding rules
Rules can be added in `mod\scripts\vscripts\takyon_rules.nut` below the "add rules here" section.

To make a new Rule add this below the other rules:

```string rule99 = "[99] this is a rule"```

Make sure it's getting diplayed by adding it to "rules". Add a ```+``` behind the last ```\n``` then add your rule with:

```rule99 + "\n"```
