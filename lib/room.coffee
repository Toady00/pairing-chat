io = require 'socket.io-client'
Emitter = require("emissary").Emitter

class Room
  Emitter.includeInto @

  constructor: ->
    @host = atom.config.get('pairing-chat.host') or 'localhost'
    @port = atom.config.get('pairing-chat.port') or 3001
    @user = atom.config.get('pairing-chat.user')
    @isConnected = false

  send: (content) ->
    message =
      user: @user
      content: content
    @socket.emit 'client:message', message

  join: (host, port) ->
    @socket = io.connect @host, {port: @port}
    @socket.on 'connect', =>
      console.log "Connected to: #{@host} on #{@port}"
      @isConnected = true
    @socket.on 'message', (data) =>
      console.log data
      @emit 'newMessage', data
    @socket.on 'close', =>
      @isConnected = false

  leave: ->
    @socket.disconnect()
    @isConnected = false

class Message
  constructor: (@content) ->

  toObj: ->
    user: 'me'
    content: @content

module.exports = { Room }
