# Utils
# -------------------------
dispatch = (target, command) ->
  atom.commands.dispatch(target, command)

# ex command
# -------------------------
w = ({editor}) ->
  editor.save()

wq = ({editor, editorElement}) ->
  editor.save()
  dispatch(editorElement, 'core:close') # FIXME

split = ({editor, editorElement}) ->
  editor.save()
  dispatch(editorElement, 'pane:split-down')

vsplit = ({editor, editorElement}) ->
  editor.save()
  dispatch(editorElement, 'pane:split-right')

# Configuration switch
# -------------------------

# Util
toggleConfig = (param) ->
  value = atom.config.get(param)
  atom.config.set(param, not value)

showInvisible = ->
  toggleConfig('editor.showInvisibles')

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

module.exports = {
  normalCommands: {
    w, wq, split, vsplit
  }
  toggleCommands: {
    showInvisible
    softWrap
    indentGuide
    lineNumbers
  }
  numberCommands: {
    moveToLine
    moveToLineByPercent
  }
}
