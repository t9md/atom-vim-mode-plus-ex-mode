{CompositeDisposable} = require 'atom'
getEditorState = null
View = require './view'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable

    scope = 'atom-text-editor:not([mini])'
    @subscriptions.add atom.commands.add scope,
      'vim-mode-plus-ex-mode:open': =>
        @getView().toggle(@getVimState())

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

  consumeVim: (service) ->
    {getEditorState} = service
