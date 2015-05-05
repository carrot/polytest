poly = require './support/poly'

describe 'basic', ->

  it 'should work', (done) ->
    poly.install ->
      poly.run(done)
