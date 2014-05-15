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
    languages = db['languages'].keys or languages
    # _classify db, tokens, languages

  # _classify:

module.exports = new Classifier()
