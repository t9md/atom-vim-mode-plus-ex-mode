{toggleConfig} = require './utils'

# ex command
# -------------------------
w = ({editor}={}) ->
  if editor?.getPath()
    editor.save()
  else
    atom.workspace.saveActivePaneItem()

q = -> atom.workspace.closeActivePaneItemOrEmptyPaneOrWindow()
wq = x = -> w(); q()
qall = -> q() for item in atom.workspace.getPaneItems()
wall = -> w({editor}) for editor in atom.workspace.getTextEditors() when editor.isModified()
wqall = xall = -> wq() for item in atom.workspace.getPaneItems()
split = ({editor, editorElement}) -> atom.commands.dispatch(editorElement, 'pane:split-down-and-copy-active-item')
vsplit = ({editor, editorElement}) -> atom.commands.dispatch(editorElement, 'pane:split-right-and-copy-active-item')
nohlsearch = ({globalState}) -> globalState.set('highlightSearchPattern', null)

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

moveToRelativeLine = (vimState, {offset}) ->
  vimState.setCount(offset + 1)
  vimState.operationStack.run('MoveToRelativeLine')

normalCommands = {
  w
  wq, x
  wall
  wqall, xall
  q
  qall
  split, vsplit
  nohlsearch
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
  moveToRelativeLine
}

module.exports = {normalCommands, toggleCommands, numberCommands}
