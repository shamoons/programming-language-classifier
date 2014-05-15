samples = require 'linguist-samples'
should = require 'should'
Classifier = require '../src/classifier'

describe 'Classifier', ->
  it 'should train the db', ->
    db = {}
    Classifier.train db, 'Ruby', samples('Ruby/foo.rb')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.h')
    Classifier.train db, 'Objective-C', samples('Objective-C/Foo.m')

    results = Classifier.classify db, samples('Objective-C/hello.m')
    # console.log db
    # console.log results
    # Classifier.train db, 'Objective-C', samples('Objective-C/Foo.h')
    # console.log db
    # console.log a
    # 1.should.be.eql 1