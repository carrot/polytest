require('coffee-script/register')

var Polytest = require('../..');
poly = new Polytest({
  cmd: 'node test/fixtures/basic.js',
  pkg: {
    "name": "test",
    "version": "0.0.0",
    "repository": {
      "type": "git",
      "url": "foobar"
    },
    "dependencies": {
      "indx": "0.2.x"
    }
  }
});

module.exports = poly;