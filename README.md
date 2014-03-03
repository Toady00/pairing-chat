## Pairing Chat

#### Chat in your Editor

This package is a first step to a larger package aimed at pair programming.

Once setup, this package provides a chat window at the bottom of your editor, where you can communicate with other developers. IN YOUR EDITOR!!!

## Usage

To connect to the server, hit ```cmd + shift + p``` and search for "Pairing Chat: Connect".

To toggle the chat window, hit ```cmd + shift + p``` and search for "Pairing Chat: Toggle".

To disconnect, hit ```cmd + shift + p``` and search for "Pairing Chat: Disconnect".

## Setup

You'll need one chat server, and any number of clients.

### Client

Go to ```Atom``` -> ```Preferences```. On the left side, scroll down until you see ```Pairing Chat```. You'll need to set the Host, Port of the server you need to connect to, as well as the User that will appear beside all the messages you send. _If you are running the server locally, it will use these same settings for host and port_.

### Server

There are two ways you can setup the server.

1. Run the chat server in your editor. Then any other users will need to connect to your server for chat. This is useful for people on the same network (ie in your office), but if you need to pair with someone remotely, you'll need to look into the next option.

2. Run the chat server on a remote server somewhere accessible by all users. This is a little bit more involved, but shouldn't be to hard.

#### Server setup in Editor

Go to ```Atom``` -> ```Preferences```. On the left side, scroll down until you see ```Pairing Chat```. You'll need to set the Host and Port the server will run on. _These are the same settings the client uses_.

Once you have your settings configured, you can start the server by hitting ```cmd + shift + p``` and searching for ```Pairing Chat: Serverstart```. Similarly you can stop the server with ```Pairing Chat: Serverstop```.

#### Remote Server setup

_Maybe still local, but not in your editor_

You can write your own server, but I've provided one below.

You'll need to have node and coffee-script installed. I wont go into installing node, but you can run

```bash
npm install -g coffee-script
```

after installing node to install coffee-script.

Add ```socket.io``` to your packages.json file. Run

```bash
npm install
```

After you've done that, write the following code to a file called app.coffee.

```coffee
# app.coffee

io = require('socket.io').listen(3001)

greeting =
  user: 'server'
  content: 'Welcome to pairing-chat'

io.sockets.on 'connection', (socket) ->
  socket.emit 'message', greeting
  socket.on 'client:message', (data) ->
    io.sockets.emit 'message', data
```

And to start the server, run

```bash
coffee app.coffee
```

## TODO:

- Colorize history
- Support for being mentioned
- TESTS!!!!
- Support for Authentication
- Encryption
- Support for Hipchat, Campfire, XMPP

## Important

:warning: This is very early in development! Alpha at best.

:warning: There is currently no security. This means:
- All messages will be unencrypted.
- All users will be unauthenticated.
