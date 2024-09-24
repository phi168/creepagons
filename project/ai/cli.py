import click 
import os

@click.command()
@click.option('--hello_arg', type=str, required=False)
def run(hello_arg):
    print(f"hello {hello_arg}")

if __name__ == '__main__':
    run()