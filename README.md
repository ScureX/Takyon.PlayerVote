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

!kick name force only works for people declared as admins in the andminNames array. This lets them kick without voting.

This feature can be disabled, even disallowing admins to kick.

There cannot be two votes at the same time. Mabye adding a time limit in the future?
