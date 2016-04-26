# vim-mode-plus-ex-mode

Experimental ex-mode support for vim-mode-plus

# NOTE for heavy ex-mode user

My thought about providing ex or command(`:`) in Atom is [here #52](https://github.com/t9md/atom-vim-mode-plus/issues/52).  
I still not much motivated for this package.   
And I have a lot of thing to do in [vim-mode-plus](https://atom.io/packages/vim-mode-plus).  
So fixing, enhancing this vim-mode-plus-ex-mode package is tend to be delayed.  
So please understand this package as reference, example, prototype implementation.  
Don't ask me to improve this package into **true** ex-mode emulation.  

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
