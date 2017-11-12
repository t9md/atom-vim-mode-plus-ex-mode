const {CompositeDisposable} = require("atom")

module.exports = {
  activate() {
    if (!atom.config.get("vim-mode-plus-ex-mode.notifiedUseExMode")) {
      const message = `Use [ex-mode](https://atom.io/packages/ex-mode) if you want better ex-mode.`
      atom.notifications.addInfo(message, {dismissable: true})
      atom.config.set("vim-mode-plus-ex-mode.notifiedUseExMode", this.notifiedUseExMode)
    }

    const consumeVimPromise = new Promise(resolve => {
      this.resolveConsumeVimPromise = resolve
    })

    const toggle = (editor, commandKind) => {
      consumeVimPromise.then(service => {
        this.getView().toggle(service.getEditorState(editor), commandKind)
      })
    }

    this.subscriptions = new CompositeDisposable(
      atom.commands.add("atom-text-editor:not([mini])", {
        "vim-mode-plus-ex-mode:open"() {
          toggle(this.getModel(), "normalCommands")
        },
        "vim-mode-plus-ex-mode:toggle-setting"() {
          toggle(this.getModel(), "toggleCommands")
        },
      })
    )
  },

  deactivate() {
    this.subscriptions.dispose()
  },

  getView() {
    if (!this.view) {
      const View = require("./view")
      this.view = new View()
    }
    return this.view
  },

  consumeVim(service) {
    class MoveToLineAndColumn extends service.Base.getClass("MoveToFirstLine") {
      constructor(...args) {
        super(...args)
        this.wise = "characterwise"
      }

      moveCursor(cursor) {
        super.moveCursor(cursor)
        cursor.setBufferPosition([cursor.getBufferRow(), this.column - 1])
      }
    }
    MoveToLineAndColumn.commandPrefix = "vim-mode-plus-user"
    MoveToLineAndColumn.register()
    this.resolveConsumeVimPromise(service)
  },
}
