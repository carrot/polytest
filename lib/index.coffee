fs            = require 'fs'
path          = require 'path'
child_process = require 'child_process'
Module        = require 'module'
npm           = require 'npm'
nodefn        = require 'when/node'
crypto        = require 'crypto'

class Polytest

  constructor: (opts) ->
    @cmd = opts.cmd
    @pkg = if typeof opts.pkg is 'object'
      opts.pkg
    else
      JSON.parse(fs.readFileSync(opts.pkg))

    @mod_path = path.resolve("polytest_#{hash_pkg(@pkg)}")

  require: (name) ->
    if not process.env.POLYTEST then return require

    _require = Module.prototype.require
    _this = this

    return Module.prototype.require = (name) ->
      hypothetical_path = path.join(_this.mod_path, 'node_modules', name)
      res = if fs.existsSync(hypothetical_path) then hypothetical_path else name
      console.log hypothetical_path
      _require.call(this, res)

  install: ->
    fs.mkdirSync(@mod_path)
    fs.writeFileSync(path.join(@mod_path, 'package.json'), JSON.stringify(@pkg))

    nodefn.call(npm.load.bind(npm), @pkg)
      .then => nodefn.call(npm.commands.install, @mod_path, [])
      .then => fs.unlinkSync(path.join(@mod_path, 'package.json'))

  run: (cb) ->
    child_process.exec @cmd, { env: { POLYTEST: true } }

  hash_pkg = (pkg) ->
    crypto.createHash('sha1').update(JSON.stringify(pkg)).digest('hex')

module.exports = Polytest