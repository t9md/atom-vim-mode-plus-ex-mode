_ = require 'underscore-plus'

toggleConfig = (param) ->
  value = atom.config.get(param)
  atom.config.set(param, not value)

humanize = (name) ->
  _.humanizeEventName(_.dasherize(name))

# Copied & modified from fuzzy-finder's code.
highlightMatches = (context, name, matches, offsetIndex=0) ->
  lastIndex = 0
  matchedChars = [] # Build up a set of matched chars to be more semantic

  for matchIndex in matches
    matchIndex -= offsetIndex
    continue if matchIndex < 0 # If marking up the basename, omit name matches
    unmatched = name.substring(lastIndex, matchIndex)
    if unmatched
      context.span matchedChars.join(''), class: 'character-match' if matchedChars.length
      matchedChars = []
      context.text unmatched
    matchedChars.push(name[matchIndex])
    lastIndex = matchIndex + 1

  context.span matchedChars.join(''), class: 'character-match' if matchedChars.length
  context.text name.substring(lastIndex) # Remaining characters are plain text

module.exports = {toggleConfig, humanize, highlightMatches}
