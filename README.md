# PlayerVote

Enables players to vote on different things like skipping a map or kicking a player, to add a true community feeling to your server!

BIG THANKS to: Coopyy, Spoon, Dullahan, Tsk22, wolf109909, Pandora and all the other people that helped me through this nightmare of a project! <3

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

# Settings
Settings are distributed in files in ```Titanfall2\R2Northstar\mods\Takyon.VoteSkipMap-2.1.0\mod\scripts\vscripts```

## takyon_playervote.nut
### adminNames
Specify player names who should be able to force votes like kick, skip and extend
```adminNames = ["name1", "name2", "name3"]```

## takyon_help.nut
### displayHintOnSpawnAmount
Amount of times (after dropship) a hint to type !help should be displayed on respawn
0: Only in dropship/initial spawn 
1: in dropship and on first respawn
etc.

## takyon_voteskip.nut
### skipEnabled
true: players can vote to skip the map
false: players **cant** vote to skip the map

## takyon_votekick.nut
### playerVoteKickEnabled
true: players can vote to kick a player
false: players **cant** vote to kick a player

### playerVotePercentage
How many people have to vote for the vote to be decided in percent
0.5: 50% of all players have to vote
0.9: 90% of all players have to vote

### minimumOnlinePlayers
How many people have to be online for a votekick to be initiated so that when 3 people are online 2 cant kick 1. Avoids trolling.

## takyon_voteextend.nut
### extendMapMultipleTimes
true: players can vote to extend the map multiple times
false: players **cant** vote to extend the map multiple times

### extendMatchTime
By how many minutes the map gets extended on vote passed
