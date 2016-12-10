{toggleConfig} = require './utils'

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
  atom.commands.dispatch(editorElement, 'pane:split-down-and-copy-active-item')

vsplit = ({editor, editorElement}) ->
  atom.commands.dispatch(editorElement, 'pane:split-right-and-copy-active-item')

# Configuration switch
# -------------------------
showInvisible = -> toggleConfig('editor.showInvisibles')
highlightSearch = -> toggleConfig('vim-mode-plus.highlightSearch')
softWrap = ({editorElement}) -> atom.commands.dispatch(editorElement, 'editor:toggle-soft-wrap')
indentGuide = ({editorElement}) -> atom.commands.dispatch(editorElement, 'editor:toggle-indent-guide')
lineNumbers = ({editorElement}) -> atom.commands.dispatch(editorElement, 'editor:toggle-line-numbers')

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

normalCommands = {
  w
  wq, x
  wall
  wqall, xall
  q
  qall
  split, vsplit
}

toggleCommands = {
  showInvisible
  softWrap
  indentGuide
  lineNumbers
  highlightSearch
}

numberCommands = {
  moveToLine
  moveToLineAndColumn
  moveToLineByPercent
}

module.exports = {normalCommands, toggleCommands, numberCommands}
