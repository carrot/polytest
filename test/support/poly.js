require('coffee-script/register')
var Polytest = require('../..');

module.exports = new Polytest({
  cmd: 'node test/fixtures/basic.js',
  pkg: {
    "name": "test",
    "version": "0.0.0",
    "repository": {
      "type": "git",
      "url": "foobar"
    },
    "dependencies": {
      "indx": "2.x"
    }
  }
});