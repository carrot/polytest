require = require('../support/poly').require();

var fs = require('fs');
console.log(fs.readFile);

var mod = require('./test/fixtures/module.js');
console.log(mod);

var indx = require('indx');
console.log(indx);