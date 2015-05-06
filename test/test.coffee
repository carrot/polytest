rimraf = require 'rimraf'
poly   = require './support/poly'

describe 'basic', ->

  it 'should work', (done) ->
    poly.install().then ->
      p = poly.run()
      p.stdout.pipe(process.stdout)
      p.on 'close', -> rimraf(poly.install_path, done)
