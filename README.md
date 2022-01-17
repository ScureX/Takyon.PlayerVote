# VoteSkipMap
Enables players to skip maps they don't like by typing !skip in the console. The map will be skipped if enough players have voted.

# Commands
## !help
Shows the player who requested it a hint, telling them to type !skip in their console if they want to skip this map

## !skip
This lets the player vote to skip the map. It sends a message to everyone showing how many people want to skip and that they can skip with !skip. If half the Players voted to skip, the game time will be set to 1 second, allowing stats to be seen and switching to a new map. 
Users cannot vote twice as their name is being tracked. They will get a message that they have already voted.
Votes are reset on map change.
