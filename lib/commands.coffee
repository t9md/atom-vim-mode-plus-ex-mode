# Utils
# -------------------------
dispatch = (target, command) ->
  atom.commands.dispatch(target, command)

# ex command
# -------------------------
w = ({editor}) ->
  editor.save()

wq = ({editor}) ->
  editor.save()
  atom.workspace.destroyActivePaneItemOrEmptyPane()

# Configuration switch
# -------------------------

# Util
toggleConfig = (param) ->
  value = atom.config.get(param)
  atom.config.set(param, not value)

toggleShowInvisible = ->
  toggleConfig('editor.showInvisibles')

toggleSoftWrap = ({editorElement}) ->
  dispatch(editorElement, 'editor:toggle-soft-wrap')

toggleLineNumbers = ({editorElement}) ->
  dispatch(editorElement, 'editor:toggle-line-numbers')

# When number was typed
# -------------------------
moveToLine = (vimState, count) ->
  vimState.count.set(count)
  vimState.operationStack.run('MoveToFirstLine')

moveToLineByPercent = (vimState, count) ->
  vimState.count.set(count)
  vimState.operationStack.run('MoveToLineByPercent')

module.exports = {
  w, wq,

  toggleShowInvisible
  toggleSoftWrap
  toggleLineNumbers

  moveToLine
  moveToLineByPercent
}
