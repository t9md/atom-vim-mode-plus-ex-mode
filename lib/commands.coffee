# Utils
# -------------------------
dispatch = (target, command) ->
  atom.commands.dispatch(target, command)

# ex command
# -------------------------
w = ->
  atom.workspace.saveActivePaneItem()

q = ->
  atom.workspace.closeActivePaneItemOrEmptyPaneOrWindow()

wq = ->
  w()
  q()

qall = ->
  q() for item in atom.workspace.getPaneItems()
    # q()
    # atom.workspace.closeActivePaneItemOrEmptyPaneOrWindow()

wqall = ->
  # wq()
  for editor in atom.workspace.getTextEditors() when editor.isModified()
    w({editor})
  qall()


split = ({editor, editorElement}) ->
  dispatch(editorElement, 'pane:split-down')

vsplit = ({editor, editorElement}) ->
  dispatch(editorElement, 'pane:split-right')


# Configuration switch
# -------------------------

# Util
toggleConfig = (param) ->
  value = atom.config.get(param)
  atom.config.set(param, not value)

showInvisible = ->
  toggleConfig('editor.showInvisibles')

highlightSearch = ->
  toggleConfig('vim-mode-plus.highlightSearch')

softWrap = ({editorElement}) ->
  dispatch(editorElement, 'editor:toggle-soft-wrap')

indentGuide = ({editorElement}) ->
  dispatch(editorElement, 'editor:toggle-indent-guide')

lineNumbers = ({editorElement}) ->
  dispatch(editorElement, 'editor:toggle-line-numbers')

# When number was typed
# -------------------------
moveToLine = (vimState, count) ->
  vimState.setCount(count)
  vimState.operationStack.run('MoveToFirstLine')

moveToLineByPercent = (vimState, count) ->
  vimState.setCount(count)
  vimState.operationStack.run('MoveToLineByPercent')

module.exports =
  normalCommands: {
    w
    wq
    wqall
    q
    qall
    split
    vsplit
  }
  toggleCommands: {
    showInvisible
    softWrap
    indentGuide
    lineNumbers
    highlightSearch
  }
  numberCommands: {
    moveToLine
    moveToLineByPercent
  }
