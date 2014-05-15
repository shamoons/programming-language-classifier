_ = require 'lodash'
Tokenizer = require 'code-tokenizer'

class Classifier
  constructor: (db = {}) ->
    @tokens_total    = db['tokens_total']
    @languages_total = db['languages_total']
    @tokens          = db['tokens']
    @language_tokens = db['language_tokens']
    @languages       = db['languages']

  train: (db, language, data) ->
    tokens = Tokenizer.tokenize data

    db['tokens_total'] = db['tokens_total'] or 0
    db['languages_total'] = db['languages_total'] or 0
    db['tokens'] = db['tokens'] or {}
    db['language_tokens'] = db['language_tokens'] or {}
    db['languages'] = db['languages'] or {}

    _.each tokens, (token) ->
      db['tokens'][language] = db['tokens'][language] or {}
      db['tokens'][language][token] = db['tokens'][language][token] or 0
      db['tokens'][language][token] += 1
      db['language_tokens'][language] = db['language_tokens'][language] or 0
      db['language_tokens'][language] += 1
      db['tokens_total'] += 1

    db['languages'][language] = db['languages'][language] or 0
    db['languages'][language] += 1
    db['languages_total'] += 1

    @tokens_total    = db['tokens_total']
    @languages_total = db['languages_total']
    @tokens          = db['tokens']
    @language_tokens = db['language_tokens']
    @languages       = db['languages']

    null

  classify: (db, tokens, languages = null) ->
    languages = languages or _.keys(db['languages'])
    _classify db, tokens, languages


  _classify = (db, tokens, languages) =>
    return [] if tokens is null
    tokens = Tokenizer.tokenize(tokens) if _.isString tokens

    scores = {}

    # TODO: ADD DEBUG

    _.each languages, (language) ->
      scores[language] = _tokens_probability(db, tokens, language) + _language_probability(language)
      #TODO: ADD DEBUG

    sortableScores = []
    _.forOwn scores, (score, key) ->
      sortableScores.push [key, score]

    sortedScores = sortableScores.sort (a, b) ->
      return b[1] - a[1]

    sortableScores

  _tokens_probability = (db, tokens, language) ->
    sum = 0.0

    _.each tokens, (token) ->
      sum += Math.log _token_probability(db, token, language)

    sum

  _token_probability = (db, token, language) =>
    tokenCount = if db['tokens'][language][token]? then db['tokens'][language][token] else 0
    if tokenCount is 0
      1 / db['tokens_total']
    else
      parseFloat(db['tokens'][language][token]) / parseFloat(db['language_tokens'][language])

  _language_probability = (language) ->
    1

module.exports = new Classifier()
