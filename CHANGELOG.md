## 0.9.0:
- New: `nohlsearch` command.

## 0.8.1:
- Keymaps: Provide default keymaps.

  ```coffeescript
  'atom-text-editor.vim-mode-plus.normal-mode':
    ':': 'vim-mode-plus-ex-mode:open'
    '!': 'vim-mode-plus-ex-mode:toggle-setting'
  ```

## 0.8.0: Unpublished because of mistake.

## 0.7.1:
- New: `Move To Relative Line` e.g. `+5`, `-5` by @gabeboning.

## 0.7.0
- Improve: Cleanup
- Improve: Cache select-list-item once generated.
- Improve: Make `MoveToLineAndColumn` motion to `characterwise`
- Breaking: List item was limited to max=5, but now no longer set max items.

## 0.6.1
- Fix: Bug

## 0.6.0
- New: `x` command(alias of `wq`) by @nwaywood
- New: `xall` command(alias of `wqall`)
- New: `moveToLineAndColumn` command. input with `line:column` e.g. `10:13`(line=10, column=13)

## 0.5.0
- Fix: Fast typing :w results in q command because #8

## 0.4.0 - Refactoring
## 0.3.0 - Improve
## 0.2.0 - First published version
## 0.1.0 - prototype
