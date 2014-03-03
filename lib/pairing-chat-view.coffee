{View} = require 'atom'
Emitter = require('emissary').Emitter

module.exports =
class PairingChatView extends View
  Emitter.includeInto @

  @content: ->
    @div class: 'pairing-chat tool-panel panel-bottom padded', =>
      @div outlet: 'history', class: 'chat-history block', =>
        @div class: 'chat-history-message block', =>
          @div 'Username: ', class: 'chat-history-user inline-block'
          @div 'Some content', class: 'chat-history-content inline-block'
      @div class: 'chat-form block', =>
        @input type: 'text', class: 'inline-block chat-form-text', outlet: 'currentMessage'
        @button class: 'btn btn-primary inline-block', click: 'send', 'send'

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

  newMessage: (user, content) ->
    @history.append View.render ->
      @div class: 'chat-history-message block', =>
        @div "#{user}: ", class: 'chat-history-sender inline-block'
        @div content, class: 'chat-history-message inline-block'

  send: ->
    content = @getCurrentMessage()
    if content?.length
      @emit 'send', content
      @clearCurrentMessage()
    @currentMessage.focus()

  getCurrentMessage: ->
    @currentMessage.val()

  clearCurrentMessage: ->
    @currentMessage.val('')
