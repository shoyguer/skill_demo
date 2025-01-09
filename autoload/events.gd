extends Node
## This is responsible for holding all global signals.


## When a player just connected, this signal will be used to updating the list of
## current connected players for the Host, telling which player should be added.
@warning_ignore("unused_signal")
signal player_connected(id: int, username: String, type: MultiplayerManager.PlayerType)

## When a player just connected, this signal will be used to updating the list of
## current connected players for the Host, telling which player should be removed.
@warning_ignore("unused_signal")
signal player_disconnected(id: int, username: String)

## When a player tries to connect to a server but it is full, this signal will
## warn the [HUD], telling the player the server is full, and that they can not
## join this game.
@warning_ignore("unused_signal")
signal warned_server_full()
