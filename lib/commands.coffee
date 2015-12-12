w = ({editor}) ->
  editor.save()

wq = ({editor}) ->
  editor.save()
  atom.workspace.destroyActivePaneItemOrEmptyPane()

moveToLine = (vimState, count) ->
  vimState.count.set(count)
  vimState.operationStack.run('MoveToFirstLine')

moveToLineByPercent = (vimState, count) ->
  vimState.count.set(count)
  vimState.operationStack.run('MoveToLineByPercent')

module.exports =
  {w, wq, moveToLine, moveToLineByPercent}
