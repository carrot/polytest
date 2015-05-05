fs            = require 'fs'
path          = require 'path'
child_process = require 'child_process'
Module        = require 'module'
npm           = require 'npm'
uuid          = require 'uuid'

class Polytest

  constructor: (opts) ->
    @cmd = opts.cmd
    @pkg = if typeof opts.pkg is 'object'
      opts.pkg
    else
      JSON.parse(fs.readFileSync(opts.pkg))

  require: (name) ->
    if not process.env.POLYTEST then return require;

    _require = Module.prototype.require
    _this = this

    return Module.prototype.require = (name) ->
      console.log fs.existsSync(path.join(_this.pkg, name))
      _require.call(this, name)

  install: (cb) ->
    fs.renameSync('node_modules', 'temp_node_modules')

    npm.load @pkg, (err) ->
      if err then return cb(err)

      npm.commands.install [], (err, data) ->
        if err then return cb(err)

        console.log data

        fs.renameSync('node_modules', "polytest_modules_#{uuid.v1()}")
        fs.renameSync('temp_node_modules', 'node_modules')

        cb()

  run: (cb) ->
    child_process.exec @cmd, { env: { POLYTEST: true } }, (err, stdout, stderr) ->
      if err then return console.error(err)
      console.log stdout
      cb()

module.exports = Polytest