_ = require 'underscore-plus'

toggleConfig = (param) ->
  value = atom.config.get(param)
  atom.config.set(param, not value)

filterItemsByName = (items, name) ->
  items.filter (item) ->
    item.name is name

humanize = (name) ->
  _.humanizeEventName(_.dasherize(name))

module.exports = {toggleConfig, filterItemsByName, humanize}
