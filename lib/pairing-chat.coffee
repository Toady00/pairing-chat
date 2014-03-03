PairingChatView = require './pairing-chat-view'
Room = require('./room').Room
ChatServer = require('./chat-server').ChatServer

module.exports =
  configDefaults:
    host: 'localhost'
    port: 3001
    user: 'me'

  pairingChatView: null

  activate: (state) ->
    @pairingChatView = new PairingChatView(state.pairingChatViewState)
    atom.workspaceView.command 'pairing-chat:connect', => @connect()
    atom.workspaceView.command 'pairing-chat:disconnect', => @disconnect()
    atom.workspaceView.command 'pairing-chat:sendmessage', => @pairingChatView.send()
    atom.workspaceView.command 'pairing-chat:serverstart', => @serverStart()
    atom.workspaceView.command 'pairing-chat:serverstop', => @serverStop()

  connect: ->
    @room = new Room()
    @room.join 'localhost', 3001
    @room.on 'newMessage', (message) =>
      @pairingChatView.newMessage message.user, message.content
    @pairingChatView.on 'send', (message) =>
      @room.send message

  disconnect: ->
    @room?.leave()

  sendMessage: (message) ->
    @room?.send(message)

  serverStart: ->
    @server = new ChatServer()
    @server.start()

  serverStop: ->
    @server?.stop()

  deactivate: ->
    @pairingChatView.destroy()

  serialize: ->
    pairingChatViewState: @pairingChatView.serialize()
