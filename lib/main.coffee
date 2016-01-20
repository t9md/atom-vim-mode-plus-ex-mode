{Emitter, CompositeDisposable} = require 'atom'
getEditorState = null
View = require './view'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor:not([mini])',
      'vim-mode-plus-ex-mode:open': =>
        if getEditorState?
          @getView().toggle(@getVimState())
        else
          @onDidConsumeVim =>
            @getView().toggle(@getVimState())
      'vim-mode-plus-ex-mode:toggle-setting': =>
        if getEditorState?
          @getView().toggle(@getVimState(), 'toggleCommands')
        else
          @onDidConsumeVim =>
            @getView().toggle(@getVimState(), 'toggleCommands')
    @emitter = new Emitter

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
