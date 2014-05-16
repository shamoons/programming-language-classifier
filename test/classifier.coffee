_ = require 'lodash'
Samples = require 'linguist-samples'
should = require 'should'
Tokenizer = require 'code-tokenizer'
Classifier = require '../src/classifier'

describe 'Classifier', ->
  it 'should classify after training', ->
    db = {}
    Classifier.train db, 'Ruby', samples('Ruby/foo.rb')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.h')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.m')


    results = Classifier.classify db, samples('Objective-C/hello.m')
    _.first(results)[0].should.eql 'Objective-C'

    tokens = Tokenizer.tokenize(samples('Objective-C/hello.m'))
    results = Classifier.classify db, tokens

    _.first(results)[0].should.eql 'Objective-C'

  it 'should classify with language restrictions', ->
    db = {}
    Classifier.train db, 'Ruby', samples('Ruby/foo.rb')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.h')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.m')

    results = Classifier.classify db, samples('Objective-C/hello.m', ['Objective-C'])
    _.first(results)[0].should.eql 'Objective-C'

    tokens = Tokenizer.tokenize(samples('Objective-C/hello.m'))
    results = Classifier.classify db, tokens, ['Ruby']

    _.first(results)[0].should.eql 'Ruby'

  it 'should classify empty data', ->
    results = Classifier.classify Samples.loadSampleFile(), ''
    _.first(results)[1].should.be.below 0.5