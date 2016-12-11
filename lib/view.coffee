_ = require 'underscore-plus'
{SelectListView, $, $$} = require 'atom-space-pen-views'
fuzzaldrin = require 'fuzzaldrin'
{humanize, highlightMatches} = require './utils'

module.exports =
class View extends SelectListView
  initialInput: null
  itemsCache: null

  # Disable throttling populateList for initialInput
  schedulePopulateList: ->
    if @initialInput
      @populateList() if @isOnDom()
      @initialInput = false
    else
      super

  initialize: ->
    @commands = require './commands'
    @addClass('vim-mode-plus-ex-mode')
    super

  getFilterKey: ->
    'displayName'

  cancelled: ->
    @hide()

  toggle: (@vimState, commandKind) ->
    if @panel?.isVisible()
      @cancel()
    else
      {@editorElement, @editor} = @vimState
      @show(commandKind)

  show: (commandKind) ->
    @initialInput = true
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel({item: this})
    @panel.show()
    @setItems(@getItemsForKind(commandKind))
    @focusFilterEditor()

  getItemsForKind: (kind) ->
    @itemsCache ?= {}
    if kind of @itemsCache
      @itemsCache[kind]
    else
      commands = _.keys(@commands[kind])
      items = commands.map (name) => @getItem(kind, name)
      @itemsCache[kind] = items
      items

  getItem: (kind, name) ->
    if kind in ['toggleCommands', 'numberCommands']
      displayName = humanize(name)
    else
      displayName = name
    {name, kind, displayName}

  hide: ->
    @panel?.hide()

  getFallBackItemsForQuery: (query) ->
    items = []

    if /^!/.test(query)
      filterQuery = query[1...] # to trim first '!'
      items = @getItemsForKind('toggleCommands')
      items = fuzzaldrin.filter(items, filterQuery, key: @getFilterKey())

    else if /^[+-\d]/.test(query)
      items.push(item) if item = @getNumberCommandItem(query)

    items

  getNumberCommandItem: (query) ->
    if match = query.match(/^(\d+)+$/)
      name = 'moveToLine'
      options = {row: Number(match[1])}

    else if match = query.match(/^(\d+)%$/)
      name = 'moveToLineByPercent'
      options = {percent: Number(match[1])}

    else if match = query.match(/^(\d+):(\d+)$/)
      name = 'moveToLineAndColumn'
      options = {row: Number(match[1]), column: Number(match[2])}

    else if match = query.match(/^([+-]\d+)$/)
      name = 'moveToRelativeLine'
      options = {offset: Number(match[1])}

    if name?
      item = @getItem('numberCommands', name)
      item.options = options
      item

  # Use as command missing hook.
  getEmptyMessage: (itemCount, filteredItemCount) ->
    @setError(null)
    @setFallbackItems(@getFallBackItemsForQuery(@getFilterQuery()))
    @selectItemView(@list.find('li:first'))

  setFallbackItems: (items) ->
    for item in items
      itemView = $(@viewForItem(item))
      itemView.data('select-list-item', item)
      @list.append(itemView)

  viewForItem: ({displayName}) ->
    # Style matched characters in search results
    filterQuery = @getFilterQuery()
    filterQuery = filterQuery[1..] if filterQuery.startsWith('!')

    matches = fuzzaldrin.match(displayName, filterQuery)
    $$ ->
      @li class: 'event', 'data-event-name': name, =>
        @span title: displayName, =>
          highlightMatches(this, displayName, matches, 0)

  confirmed: ({kind, name, options}) ->
    @cancel()
    @commands[kind][name](@vimState, options)
