{View} = require 'atom'
Emitter = require('emissary').Emitter
thisUser = atom.config.get('pairing-chat.user')

module.exports =
class PairingChatView extends View
  Emitter.includeInto @

  @content: ->
    @div class: 'pairing-chat tool-panel panel-bottom padded', =>
      @div outlet: 'history', class: 'chat-history block', =>
      @div class: 'chat-form block', =>
        @input type: 'text', class: 'inline-block chat-form-text', outlet: 'currentMessage'
        @button class: 'btn btn-primary inline-block', click: 'send', 'send'
        @button class: 'btn btn-warning', click: 'clearCurrentMessage', 'clear'

  initialize: (serializeState) ->
    atom.workspaceView.command "pairing-chat:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      console.log "PairingChatView was toggled off!"
      @detach()
    else
      console.log "PairingChatView was toggled on!"
      atom.workspaceView.appendToBottom(this)
      @focus()

  # TODO: Consider making messages a partial view
  newMessage: (user, content) ->
    userClass = @classFor(user)
    @history.append View.render ->
      @div class: "chat-history-message block #{userClass}", =>
        @div "#{user}: ", class: 'chat-history-sender inline-block'
        @div content, class: 'chat-history-message inline-block'

  send: ->
    content = @getCurrentMessage()
    if content?.length
      @emit 'send', content
      @clearCurrentMessage()
    @focus()

  getCurrentMessage: ->
    @currentMessage.val()

  clearCurrentMessage: ->
    @currentMessage.val('')
    @focus()

  classFor: (user) ->
    if user is thisUser
      'text-info'
    else if user is 'server'
      'text-highlight'
    else
      ''

  focus: ->
    @currentMessage.focus()
