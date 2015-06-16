fs            = require 'fs'
path          = require 'path'
child_process = require 'child_process'
Module        = require 'module'
npm           = require 'npm'
crypto        = require 'crypto'
rimraf        = require 'rimraf'

class Polytest

  ###*
   * Constructor, requires an object with 'cmd' and 'pkg', sets up the polytest
   * install folder path.
   * @param  {Object} opts - requires 'cmd' a string, and 'pkg' a path or object
  ###

  constructor: (opts) ->
    @cmd = opts.cmd
    @pkg = if typeof opts.pkg is 'object'
      opts.pkg
    else
      JSON.parse(fs.readFileSync(opts.pkg))

    @path = path.resolve("polytest_#{hash_pkg(@pkg)}")

  ###*
   * Patched require function that pulls from polytest's custom node modules
   * folder when the correct environment variable is there
   * @return {Function} node's require function, patched
  ###

  require: ->
    if not process.env.POLYTEST then return require

    _require = Module.prototype.require
    _this = this

    return Module.prototype.require = (name) ->
      hypothetical_path = path.join(_this.path, 'node_modules', name)
      res = if fs.existsSync(hypothetical_path) then hypothetical_path else name
      _require.call(this, res)

  ###*
   * Runs 'npm install' using the custom 'package.json' file provided. Installs
   * to a folder called 'polytest_xxx', with xxx being a hash of the package
   * file's contents. Hits a callback when finished.
   * @param  {Function} cb callback to be run when the install has finished
  ###

  install: (cb) ->
    if not fs.existsSync(@path)
      fs.mkdirSync(@path)
      fs.writeFileSync(path.join(@path, 'package.json'), JSON.stringify(@pkg))

    npm.load @pkg, =>
      npm.commands.install(@path, [], cb)

  ###*
   * Runs the specified command, adding the POLYTEST environment variable
   * necessary to activate polytest.
   * @return {Stream} child_process direct return stream object
  ###

  run: ->
    env_dupe = {}
    env_dupe[v] = process.env[v] for v in process.env
    env_dupe.POLYTEST = true

    child_process.exec @cmd, { env: env_dupe }

  ###*
   * Removes the custom installed polytest node modules folder asynchronously.
   * @param  {Function} cb callback to be run when modules are removed
  ###

  remove_modules: (cb) ->
    rimraf(@path, cb)

  ###*
   * Creates a sha1 hash of the custom package.json file's contents as an id.
   * @param  {Object} pkg - contents of the custom package.json file
   * @return {String} hashed json object as a string
  ###

  hash_pkg = (pkg) ->
    crypto.createHash('sha1').update(JSON.stringify(pkg)).digest('hex')

module.exports = Polytest