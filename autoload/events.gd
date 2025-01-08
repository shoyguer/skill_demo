extends Node
## This is responsible for holding all global signals.


## When a player just connected, this signal will be used to updating the list of
## current connected players for the Host, telling which player should be added.
@warning_ignore("unused_signal")
signal player_connected(id: int, username: String)

## When a player just connected, this signal will be used to updating the list of
## current connected players for the Host, telling which player should be removed.
@warning_ignore("unused_signal")
signal player_disconnected(id: int, username: String)
