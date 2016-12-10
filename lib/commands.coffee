# Utils
# -------------------------
dispatch = (target, command) ->
  atom.commands.dispatch(target, command)

# ex command
# -------------------------
w = ({editor}={}) ->
  if editor?.getPath()
    editor.save()
  else
    atom.workspace.saveActivePaneItem()

q = -> atom.workspace.closeActivePaneItemOrEmptyPaneOrWindow()

wq = -> w(); q()
x = wq

qall = -> q() for item in atom.workspace.getPaneItems()
wall = -> w({editor}) for editor in atom.workspace.getTextEditors() when editor.isModified()

wqall = -> wq() for item in atom.workspace.getPaneItems()
xall = wqall

split = ({editor, editorElement}) ->
  dispatch(editorElement, 'pane:split-down-and-copy-active-item')

vsplit = ({editor, editorElement}) ->
  dispatch(editorElement, 'pane:split-right-and-copy-active-item')

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
moveToLine = (vimState, {row}) ->
  vimState.setCount(row)
  vimState.operationStack.run('MoveToFirstLine')

moveToLineAndColumn = (vimState, {row, column}) ->
  vimState.setCount(row)
  vimState.operationStack.run('MoveToLineAndColumn', {column})

moveToLineByPercent = (vimState, {percent}) ->
  vimState.setCount(percent)
  vimState.operationStack.run('MoveToLineByPercent')

module.exports =
  normalCommands: {
    w
    wq, x
    wall
    wqall, xall
    q
    qall
    split, vsplit
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
    moveToLineAndColummn
    moveToLineByPercent
  }
