var chai = require('chai'),
    chai_fs = require('chai-fs'),
    Polytest = require('../..');

var should = chai.should();
chai.use(chai_fs);

global.should = should;
global.Polytest = Polytest;
