_ = require 'lodash'
samples = require 'linguist-samples'
should = require 'should'
Tokenizer = require 'code-tokenizer'
Classifier = require '../src/classifier'

describe 'Classifier', ->
  it 'should train the db', ->
    db = {}
    Classifier.train db, 'Ruby', samples('Ruby/foo.rb')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.h')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.m')


    results = Classifier.classify db, samples('Objective-C/hello.m')
    _.first(results)[0].should.eql 'Objective-C'

    tokens = Tokenizer.tokenize(samples('Objective-C/hello.m'))
    results = Classifier.classify db, tokens

    _.first(results)[0].should.eql 'Objective-C'