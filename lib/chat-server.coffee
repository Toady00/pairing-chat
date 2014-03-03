greeting =
  user: 'server'
  content: 'Welcome to pairing-chat'

class ChatServer
  constructor: ->
    @host = atom.config.get('pairing-chat.host') or 'localhost'
    @port = atom.config.get('pairing-chat.port') or 3001

  start: ->
    @io = require('socket.io').listen(3001)

    @io.sockets.on 'connection', (socket) ->
      socket.emit 'message', greeting
      socket.on 'client:message', (data) ->
        socket.emit 'message', data

  stop: ->
    @io.server.close()

module.exports = { ChatServer }
