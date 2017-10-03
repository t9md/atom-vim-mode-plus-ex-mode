const _ = require("underscore-plus")
const {SelectListView, $, $$} = require("atom-space-pen-views")
const fuzzaldrin = require("fuzzaldrin")

module.exports = class View extends SelectListView {
  // Disable throttling populateList for initialInput
  schedulePopulateList() {
    if (this.initialInput) {
      if (this.isOnDom()) this.populateList()
      this.initialInput = false
    } else {
      super.schedulePopulateList()
    }
  }

  initialize() {
    this.commandsByKind = require("./commands")
    this.commandItemsByKind = {}
    this.panel = atom.workspace.addModalPanel({item: this, visible: false})

    for (const kind in this.commandsByKind) {
      const commandNames = Object.keys(this.commandsByKind[kind])
      this.commandItemsByKind[kind] = commandNames.map(name => this.buildItem(kind, name))
    }
    this.addClass("vim-mode-plus-ex-mode")
    super.initialize()
  }

  getFilterKey() {
    return "displayName"
  }

  cancelled() {
    this.panel.hide()
  }

  toggle(vimState, commandKind) {
    if (this.panel.isVisible()) {
      this.cancel()
    } else {
      this.vimState = vimState

      this.initialInput = true
      this.storeFocusedElement()
      this.panel.show()
      this.setItems(this.commandItemsByKind[commandKind])
      this.focusFilterEditor()
    }
  }

  buildItem(kind, name, options) {
    const displayName = ["toggleCommands", "numberCommands"].includes(kind)
      ? _.humanizeEventName(_.dasherize(name))
      : name
    return {name, kind, displayName, options}
  }

  getFallBackItemsForQuery(query) {
    if (/^!/.test(query)) {
      const filterQuery = query.slice(1) // to trim first '!'
      const items = this.commandItemsByKind["toggleCommands"]
      return fuzzaldrin.filter(items, filterQuery, {key: this.getFilterKey()})
    } else if (/^[+-\d]/.test(query)) {
      const item = this.getNumberCommandItem(query)
      if (item) return [item]
    }
    return []
  }

  getNumberCommandItem(query) {
    const buildItem = this.buildItem.bind(this, "numberCommands")

    let match
    if ((match = query.match(/^(\d+)+$/))) {
      return buildItem("moveToLine", {row: Number(match[1])})
    } else if ((match = query.match(/^(\d+)%$/))) {
      return buildItem("moveToLineByPercent", {percent: Number(match[1])})
    } else if ((match = query.match(/^(\d+):(\d+)$/))) {
      return buildItem("moveToLineAndColumn", {row: Number(match[1]), column: Number(match[2])})
    } else if ((match = query.match(/^([+-]\d+)$/))) {
      return buildItem("moveToRelativeLine", {offset: Number(match[1])})
    }
  }

  // Use as command missing hook.
  getEmptyMessage(itemCount, filteredItemCount) {
    this.setError(null)
    this.setFallbackItems(this.getFallBackItemsForQuery(this.getFilterQuery()))
    return this.selectItemView(this.list.find("li:first")) // FIXME
  }

  setFallbackItems(items) {
    for (const item of items) {
      const itemView = $(this.viewForItem(item))
      itemView.data("select-list-item", item)
      this.list.append(itemView)
    }
  }

  viewForItem({displayName}) {
    // Style matched characters in search results
    let filterQuery = this.getFilterQuery()
    if (filterQuery.startsWith("!")) {
      filterQuery = filterQuery.slice(1)
    }

    const matches = fuzzaldrin.match(displayName, filterQuery)
    return $$(function() {
      this.li({class: "event", "data-event-name": name}, () => {
        this.span({title: displayName}, () => {
          highlightMatches(this, displayName, matches, 0)
        })
      })
    })
  }

  confirmed({kind, name, options}) {
    this.cancel()
    this.commandsByKind[kind][name](this.vimState, options)
  }
}

function highlightMatches(context, name, matches, offsetIndex = 0) {
  let lastIndex = 0
  let matchedChars = [] // Build up a set of matched chars to be more semantic

  for (let matchIndex of matches) {
    matchIndex -= offsetIndex
    if (matchIndex < 0) continue

    // If marking up the basename, omit name matches
    const unmatched = name.substring(lastIndex, matchIndex)
    if (unmatched) {
      if (matchedChars.length) {
        context.span(matchedChars.join(""), {class: "character-match"})
      }
      matchedChars = []
      context.text(unmatched)
    }
    matchedChars.push(name[matchIndex])
    lastIndex = matchIndex + 1
  }

  if (matchedChars.length) {
    context.span(matchedChars.join(""), {class: "character-match"})
  }
  // Remaining characters are plain text
  context.text(name.substring(lastIndex))
}
