poly   = require './support/poly'

describe 'basic', ->

  it 'should install deps to a separate folder', (done) ->
    poly.install().then ->
      poly.path.should.be.a.directory()
      done()

  it 'works with a done argument', (done) ->
    p = poly.run()
    i = 0

    p.stderr.once('data', done)

    p.stdout.on 'data', (data) ->
      switch i
        when 0
          if data == '[Function]\n' then i++
        when 1
          if data == 'wow\n' then i++
        when 2
          if data == '[Function]\n' then i++

    p.on 'close', ->
      p.stdout.removeAllListeners()
      i.should.eql(3)
      done()

  it 'works when run a second time to reinstall', (done) ->
    poly.install().then(-> done())

  # it 'should not mess up normally run tests'

  after (done) -> poly.remove_modules(done)

