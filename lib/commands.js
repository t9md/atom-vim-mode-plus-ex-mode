// ex command
// -------------------------
function w({editor} = {}) {
  if (editor && editor.getPath()) {
    editor.save()
  } else {
    atom.workspace.saveActivePaneItem()
  }
}

function q() {
  atom.workspace.closeActivePaneItemOrEmptyPaneOrWindow()
}

function wq() {
  w()
  q()
}

function qall() {
  atom.workspace.getPaneItems().forEach(() => q())
}

function wall() {
  atom.workspace
    .getTextEditors()
    .filter(editor => editor.isModified())
    .forEach(editor => w({editor}))
}

function wqall() {
  atom.workspace.getPaneItems().forEach(() => wq())
}

function split({editorElement}) {
  atom.commands.dispatch(editorElement, "pane:split-down-and-copy-active-item")
}

function vsplit({editorElement}) {
  atom.commands.dispatch(editorElement, "pane:split-right-and-copy-active-item")
}

function nohlsearch({globalState}) {
  globalState.set("highlightSearchPattern", null)
}

// Configuration switch
// -------------------------
function toggleConfig(param) {
  atom.config.set(param, !atom.config.get(param))
}

function showInvisible() {
  toggleConfig("editor.showInvisibles")
}

function highlightSearch() {
  toggleConfig("vim-mode-plus.highlightSearch")
}

function softWrap({editorElement}) {
  atom.commands.dispatch(editorElement, "editor:toggle-soft-wrap")
}

function indentGuide({editorElement}) {
  atom.commands.dispatch(editorElement, "editor:toggle-indent-guide")
}

function lineNumbers({editorElement}) {
  atom.commands.dispatch(editorElement, "editor:toggle-line-numbers")
}

// When number was typed
// -------------------------
function moveToLine(vimState, {row}) {
  vimState.operationStack.run("MoveToFirstLine", {count: row})
}

function moveToLineAndColumn(vimState, {row, column}) {
  vimState.operationStack.run("MoveToLineAndColumn", {count: row, column})
}

function moveToLineByPercent(vimState, {percent}) {
  vimState.operationStack.run("MoveToLineByPercent", {count: percent})
}

function moveToRelativeLine(vimState, {offset}) {
  vimState.operationStack.run("MoveToRelativeLine", {count: offset + (offset > 0 ? 1 : -1)})
}

const x = wq
const xall = wqall
const normalCommands = {
  w,
  wq,
  x,
  wall,
  wqall,
  xall,
  q,
  qall,
  split,
  vsplit,
  nohlsearch,
}

const toggleCommands = {
  showInvisible,
  softWrap,
  indentGuide,
  lineNumbers,
  highlightSearch,
}

const numberCommands = {
  moveToLine,
  moveToLineAndColumn,
  moveToLineByPercent,
  moveToRelativeLine,
}

module.exports = {normalCommands, toggleCommands, numberCommands}
