var chai = require('chai'),
    polytest = require('../..');

var should = chai.should();

// this is a great place to initialize chai plugins
// http://chaijs.com/plugins

global.polytest = polytest;
global.should = should;
