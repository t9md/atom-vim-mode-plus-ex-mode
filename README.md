# vim-mode-plus-ex-mode

Experimental ex-mode support for vim-mode-plus

## keymap

There is no default keymap.

```coffeescript
'atom-text-editor.vim-mode-plus.normal-mode':
  ':': 'vim-mode-plus-ex-mode:open'
  '!': 'vim-mode-plus-ex-mode:toggle-setting'
```

# How to use

`11` to move to line 11
`50%` to move to 50% of buffer.
`!` to toggle bolean config parameter
`w`, `wq`, `split`, `vsplit`
