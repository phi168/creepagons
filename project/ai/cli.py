import click 
import os
import ast
import numpy as np


def get_value(d, key):
    return d[key]

@click.command()
@click.option('--_owner', required=False)
@click.option('--health', required=False)
@click.option('--health_delta', required=False)
@click.option('--is_in_game', required=False)
def run(_owner, health, health_delta, is_in_game):
    game_state = {}
    arg_keys = ['owner', 'health', 'health_delta', 'is_in_game']
    for i, arg in enumerate([_owner, health, health_delta, is_in_game]):
        arg = ast.literal_eval(arg.replace("false", "False").replace("true", "True"))
        if arg_keys[i] == 'health_delta':
            val = np.array(arg)
            vectorized_get_value = np.vectorize(get_value)
            game_state['health_delta_1'] = vectorized_get_value(val, 1)
            game_state['health_delta_2'] = vectorized_get_value(val, 2)
        else:
            game_state[arg_keys[i]] = np.array(arg).astype(int)

    move = get_move(game_state)
    print(move)


def get_move(game_state):
    possible_moves = np.argwhere(game_state['is_in_game'] == 1)
    move = np.random.choice(possible_moves.shape[0])

    return possible_moves[move]


if __name__ == '__main__':
    health_delta = "[[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:1,2:0},{1:1,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:1,2:0},{1:1,2:0},{1:1,2:1},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:1,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:1,2:0},{1:0,2:0},{1:1,2:0},{1:1,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:1,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}],[{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0},{1:0,2:0}]]"
    _owner="[[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,2,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,2,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,1,1,1,1,0,0,0,0,0],[0,0,1,1,1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,2,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,2,0,0,0,0,2,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0]]"
    health="[[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,1,1,1,1,0,0,0,0,0],[0,0,1,1,1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0]]"
    is_in_game="[[false,false,false,true,true,true,true,true,true,false,false,false],[false,false,true,true,true,true,true,true,true,false,false,false],[false,false,true,true,true,true,true,true,true,true,false,false],[false,true,true,true,true,true,true,true,true,true,false,false],[false,true,true,true,true,true,true,true,true,true,true,false],[true,true,true,true,true,true,true,true,true,true,true,false],[true,true,true,true,true,true,true,true,true,true,true,true],[true,true,true,true,true,true,true,true,true,true,true,false],[false,true,true,true,true,true,true,true,true,true,true,false],[false,true,true,true,true,true,true,true,true,true,false,false],[false,false,true,true,true,true,true,true,true,true,false,false],[false,false,true,true,true,true,true,true,true,false,false,false],[false,false,false,true,true,true,true,true,true,false,false,false]]"
    run()

