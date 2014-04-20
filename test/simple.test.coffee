should = require 'should'

require_modules = require '../lib'

describe 'Require Modules', ->


  it 'should require modules in specified directory', (done) ->
    dummy = require_modules "#{__dirname}/dummy"
    dummy.foo.should.equal 'bar'

    [dummy, test_module] = require_modules "#{__dirname}/dummy", "#{__dirname}/test_module"
    dummy.foo.should.equal 'bar'
    test_module.config.value.should.equal 'development'
    done()

  it "should return corresponding object if environment is detected", (done) ->
    modules = require_modules "#{__dirname}/dummy"
    modules.dummy.value.should.equal 'development'
    done()

  it "should return corresponding object if environment detecting is turned off", (done) ->
    modules = require_modules "dummy", detect_env: false
    should.not.exists modules.dummy.value
    modules.dummy.development.value.should.equal 'development'
    done()
