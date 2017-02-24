# vim-mode-plus-ex-mode

Experimental ex-mode support for vim-mode-plus

## How to use?

Default keymaps are provided from v0.8.0.
In `normal-mode`, following keymaps are available.

- `:`: `vim-mode-plus-ex-mode:open`: open ex-mode then can use following operations
  - `11`: Move to line 11.
  - `+11`, `-11`: Move to relative line.
  - `50%`: Move to 50% of buffer..
  - `15:10`: Move to line 15, column 10
  - `!`: Toggle boolean config parameter.
  - `w`, `wq`, `split`, `vsplit` etc.
  - `nohlsearch`: to clear `highlight-search`.

- `!`: `vim-mode-plus-ex-mode:toggle-setting`: toggle boolean setting-value.
  - Choose setting parameter to toggle boolean value.
  - Shorthand of `:` then input `!`

## NOTE for heavy ex-mode user

I'm not motivated for this package.   
My thought for providing ex-mode(`:` command) in Atom is [here #52](https://github.com/t9md/atom-vim-mode-plus/issues/52).  
Please understand this package as reference, example, prototype implementation.  
Don't ask me to improve this package into **true** ex-mode emulation.  

Instead, you can learn

- [Atom's way](https://flight-manual.atom.io/)
- [vim-mode-plus's way](https://github.com/t9md/atom-vim-mode-plus/wiki)

For example, there are quicker and effective ways than doing `s/abc/def/g`.  
By using Atom's multiple-cursors, and also vim-mod-plus's `occurrence` feature(unique enhancement).  
