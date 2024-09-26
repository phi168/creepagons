import asyncio
import websockets
import ast
import numpy as np
import torch

from model import ConvNet


def get_value(d, key):
    return d[key]


class Game:
    def __init__(self, client_id, player_id=None):
        self.client_id = client_id
        self.player_id = player_id  # Stores which player this client is
        self.current_player = None  # Stores whose turn it is in the game
        self.game_state = None      # Stores the current game state

    def parse_response(self, response):
        """
        Parse the response from the server and update game state.
        Response could be PLAYERID:<id> or a game state update.
        """
        if response.startswith("PLAYERID:"):
            self.player_id = int(response.split(":")[1])
            print(f"Assigned player ID: {self.player_id}", end='; ')
        elif response == 'ACK':
            # do nothing
            return
        else:
            self.parse_state(response)

    def parse_state(self, state):
        """
        Parse the game state.
        Assume state is something like "STATE:current_player,game_data".
        """
        game_states = state.split(';')
        game_state = {}
        for state in game_states:
            keyval = state.split(':', 1)
            key = keyval[0]
            val = keyval[1]
            val = ast.literal_eval(val.replace("false", "False").replace("true", "True"))
            if key == 'health_delta':
                val = np.array(val)
                vectorized_get_value = np.vectorize(get_value)
                game_state['health_delta_1'] = vectorized_get_value(val, "1")
                game_state['health_delta_2'] = vectorized_get_value(val, "2")
            else:
                game_state[key] = np.array(val).astype(int)

        self.current_player = game_state['current_player_id']
        self.game_state = game_state

    def is_my_turn(self):
        """Check if it's this player's turn."""
        return self.current_player == self.player_id

    def decide_move(self):
        """
        Make a move based on the current game state
        """
        s = self.game_state
        o = s['_owner']
        if s['current_player_id'] == 2:
            o[o == 2] = - 1
            input = np.stack([o, s['health_delta_2'], s['health_delta_1'], s['is_in_game']])
        else:
            o[o == 1] = - 1
            o[o == 2] = 1
            input = np.stack([o, s['health_delta_1'], s['health_delta_2'], s['is_in_game']])

        in_channels, height, width = input.shape
        model = ConvNet(in_channels, height, width)
        x = torch.from_numpy(input).unsqueeze(0).type(torch.float32)
        move = model(x).squeeze()
        return f"MOVE:{move[0]},{move[1]}"


async def connect_to_server(uri, client_id):
    # Establish WebSocket connection
    game = Game(client_id)
    async with websockets.connect(uri) as websocket:
        print(f"Client {client_id}: Connected to the server")
        while True:
            # Wait for game to start
            response = await websocket.recv()
            if response == 'ACK':
                # ignore this
                continue
            if response.startswith("WINNER:"):
                winner = int(response.split(":")[1])
                print(f"Game over. Winner: player {winner}")
                return game
            # Parse the response and update game state
            game.parse_response(response)
            # Check if it's this player's turn
            if game.is_my_turn():
                # Decide on a move and send it
                move = game.decide_move()
                await websocket.send(move)
                print(f"Client {game.player_id}: Sent: {move}")

            await asyncio.sleep(0.01)


async def run_multiple_clients():
    uri = "ws://localhost:8081"

    # Start two clients concurrently
    games = await asyncio.gather(
        connect_to_server(uri, client_id=1),  # Client 1
        connect_to_server(uri, client_id=2)   # Client 2
    )
    game = games[0]



def run():
    asyncio.get_event_loop().run_until_complete(run_multiple_clients())


if __name__ == '__main__':
    run()