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

    null

  classify: (db, tokens, languages = null) ->
    languages = _.keys(db['languages']) or languages
    _classify db, tokens, languages

  _classify = (db, tokens, languages) ->
    return [] if tokens is null
    tokens = Tokenizer.tokenize(tokens) if _.isString tokens

    score = {}

    # TODO: ADD DEBUG

    _.each languages, (language) ->
      score[language] = tokens_probability(tokens, language) + language_probability(language)
      #TODO: ADD DEBUG

    # _.sort scores, 

    console.log scores

  tokens_probability = (tokens, language) ->
    sum = 0.0
    _.each tokens, (token) ->
      sum += token_probability(tokens, token, language)

  token_probability = (tokens, token, language) ->
    console.log tokens

module.exports = new Classifier()
