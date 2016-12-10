{Emitter, CompositeDisposable} = require 'atom'
getEditorState = null

module.exports =
  activate: ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable
    self = this
    @subscriptions.add atom.commands.add 'atom-text-editor:not([mini])',
      'vim-mode-plus-ex-mode:open': ->
        self.toggle(@getModel(), 'normalCommands')
      'vim-mode-plus-ex-mode:toggle-setting': ->
        self.toggle(@getModel(), 'toggleCommands')

  toggle: (editor, commandKind) ->
    @getEditorState(editor).then (vimState) =>
      @getView().toggle(vimState, commandKind)

  getEditorState: (editor) ->
    if getEditorState?
      Promise.resolve(getEditorState(editor))
    else
      new Promise (resolve) =>
        @onDidConsumeVim ->
          resolve(getEditorState(editor))

  deactivate: ->
    @subscriptions.dispose()
    @view?.destroy?()
    {@subscriptions, @view} = {}

  getView: ->
    @view ?= new (require('./view'))

  onDidConsumeVim: (fn) ->
    @emitter.on('did-consume-vim', fn)

  consumeVim: (service) ->
    {getEditorState, Base} = service
    Motion =

    # keymap: g g
    class MoveToLineAndColumn extends Base.getClass('MoveToFirstLine')
      @extend()
      @commandPrefix: 'vim-mode-plus-user'
      wise: 'characterwise'
      column: null

      moveCursor: (cursor) ->
        super
        point = [cursor.getBufferRow(), @column - 1]
        cursor.setBufferPosition(point)

    @emitter.emit('did-consume-vim')
