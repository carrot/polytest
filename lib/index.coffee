fs            = require 'fs'
path          = require 'path'
child_process = require 'child_process'
Module        = require 'module'
npm           = require 'npm'
nodefn        = require 'when/node'
crypto        = require 'crypto'
rimraf        = require 'rimraf'

class Polytest

  constructor: (opts) ->
    @cmd = opts.cmd
    @pkg = if typeof opts.pkg is 'object'
      opts.pkg
    else
      JSON.parse(fs.readFileSync(opts.pkg))

    @path = path.resolve("polytest_#{hash_pkg(@pkg)}")

  require: (name) ->
    if not process.env.POLYTEST then return require

    _require = Module.prototype.require
    _this = this

    return Module.prototype.require = (name) ->
      hypothetical_path = path.join(_this.path, 'node_modules', name)
      res = if fs.existsSync(hypothetical_path) then hypothetical_path else name
      _require.call(this, res)

  install: ->
    if not fs.existsSync(@path)
      fs.mkdirSync(@path)
      fs.writeFileSync(path.join(@path, 'package.json'), JSON.stringify(@pkg))

    nodefn.call(npm.load.bind(npm), @pkg)
      .then => nodefn.call(npm.commands.install, @path, [])

  run: ->
    child_process.exec @cmd, { env: { POLYTEST: true } }

  remove_modules: (cb) ->
    rimraf(@path, cb)

  hash_pkg = (pkg) ->
    crypto.createHash('sha1').update(JSON.stringify(pkg)).digest('hex')

module.exports = Polytest