#!/usr/bin/python3
# -*-coding:Utf-8 -*

import select, socket, sys
from lobby import Room, Lobby
import lobby
from player import Player
import player

READ_BUFFER = 4096
host = "127.0.0.1"
port = 8888


server_connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# can re-use adress with option SO_REUSEADDR
server_connection.connect((host,port))

# function to have a prompt
def prompt():
    print('>', end=' ', flush = True)

print("Connected to server\n")
msg_prefix = ''

socket_list = [sys.stdin, server_connection]

while True:
    # using function select to connect several socket to the server
    read_sockets, write_sockets, error_sockets = select.select(socket_list, [], [])
    for s in read_sockets:
        if s is server_connection: # new message
            msg = s.recv(READ_BUFFER)
            if not msg:
                # server down
                print("Server down!")
                sys.exit(2)
            else:
                if msg == lobby.QUIT_STRING.encode():
                    # client quit server
                    sys.stdout.write('Bye\n')
                    sys.exit(2)
                else:
                    # send to the server what the client write
                    sys.stdout.write(msg.decode())
                    if '<name>' in msg.decode():
                        msg_prefix = 'name:' # prefix message with name client
                    else:
                        msg_prefix = ''
                    prompt()

        else:
            msg = msg_prefix + sys.stdin.readline()
            server_connection.sendall(msg.encode())