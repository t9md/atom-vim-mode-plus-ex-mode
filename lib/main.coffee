{Emitter, CompositeDisposable} = require 'atom'
getEditorState = null
View = require './view'

module.exports =
  activate: ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor:not([mini])',
      'vim-mode-plus-ex-mode:open': => @toggle('normalCommands')
      'vim-mode-plus-ex-mode:toggle-setting': => @toggle('toggleCommands')

  toggle: (commandKind) ->
    if getEditorState?
      @getView().toggle(@getVimState(), commandKind)
    else
      @onDidConsumeVim =>
        @getView().toggle(@getVimState(), commandKind)

  deactivate: ->
    @subscriptions.dispose()
    @view?.destroy?()
    {@subscriptions, @view} = {}

  getView: ->
    return @view if @view?
    View.init()
    @view = new View()

  getVimState: ->
    editor = atom.workspace.getActiveTextEditor()
    getEditorState(editor)

  onDidConsumeVim: (fn) ->
    @emitter.on 'did-consume-vim', fn

  consumeVim: (service) ->
    {getEditorState} = service
    @emitter.emit 'did-consume-vim'
