# Polytest

[![npm](http://img.shields.io/npm/v/polytest.svg?style=flat)](https://badge.fury.io/js/polytest) [![tests](http://img.shields.io/travis/carrot/polytest/master.svg?style=flat)](https://travis-ci.org/carrot/polytest) [![dependencies](http://img.shields.io/gemnasium/carrot/polytest.svg?style=flat)](https://gemnasium.com/carrot/polytest)

Test multiple versions of node dependencies

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

### Why should you care?

If you want to run tests in node using multiple versions of one or more dependencies from your `package.json` file, this is currently not possible, as only one version can be installed at a time. This has been confirmed by Isaacs [here](https://github.com/npm/npm/issues/5499#issuecomment-71930827). The suggestion he makes for solving the problem is to set up a script that installs multiple versions of the dependency in other directories, which is less than ideal.

This library takes care of the "test multiple version of dependencies" issue without you needing to hack together a script to do so, which turns out to be quite ugly and difficult.

### Installation

`npm i polytest`

### Usage

The purpose of this script is to be able to run a specific test suite with a specific set of dependencies, independent of your `package.json` file. As such, `polytest` takes two arguments. The first is the command you use to run the test suite, and the second is a JSON object representing a `package.json` file, or a string that represents a path where one can be loaded. For example:

```js
var polytest = require('polytest');

polytest('mocha test/old/all.js', 'test/old/package.json')
  .pipe(process.stdout)
```

A couple things happening here. First of all, you can see the two arguments as described above -- command to run the tests and path to a `package.json` file with which to run the tests. Second, you'll notice these are relative paths. These will be executed relative to the file in which polytest is being run. If this is confusing or tripping you up, feel free to simply pass an absolute path. Finally, you'll notice that it returns a stream. The stream will simply pass through the command's output and you can do whatever you'd like with it, in the above example it's just logged through the console.

### License & Contributing

- Details on the license [can be found here](LICENSE.md)
- Details on running tests and contributing [can be found here](contributing.md)
