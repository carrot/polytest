poly   = require './support/poly'

describe 'basic', ->

  it 'should install deps to a separate folder', (done) ->
    poly.install ->
      poly.path.should.be.a.directory()
      done()

  it 'should use polytest dependencies when running through polytest', (done) ->
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
    poly.install(-> done())

  # unfortunately at the moment it actually does mess up normal test
  # also the module resolution algorithm is incorrect
  it 'should not mess up normally run tests'

  after (done) -> poly.remove_modules(done)

