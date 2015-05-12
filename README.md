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

The purpose of this script is to be able to run a specific test suite with a specific set of dependencies, independent of your `package.json` file. In order to get set up, you must initialize a polytest object with the alternate `package.json` you want to use and the command to run the tests. As such, the constructor takes two arguments. The first is the command you use to run the test suite, and the second is a JSON object representing a `package.json` file, or a string that represents a path where one can be loaded. For example:

```js
var Polytest = require('polytest');

module.exports = new Polytest({
  cmd: 'mocha test/old/all.js',
  pkg: 'test/old/package.json'
});
```

A couple things happening here. First of all, you can see the two arguments as described above -- command to run the tests and path to a `package.json` file with which to run the tests. These arguments are accepted through an object. The `cmd` option takes a string, which is a command to be run via command line. The `pkg` argument takes either a string, which is a path to a `package.json` file, or an object, which is the contents of a `package.json` file.

Second, you'll notice these are relative paths. These will be executed relative to the `cwd` from which polytest is executed. If this is confusing or tripping you up, feel free to simply pass an absolute path. Finally, you'll notice that it returns a stream. The stream will simply pass through the command's output and you can do whatever you'd like with it, in the above example it's just logged through the console.

Now, in order to install the alternate dependencies and run the test suite, you can use `polytest.install` and `polytest.run`, respectively.

```js
var polytest = require('./path_to_above_example');

polytest.install(function(){
  polytest.run().pipe(process.stdout);
});
```

So here, we require the initialized polytest object, install the dependencies, and after this is done, run the tests. `polytest.run` returns a stream of the test output, and here we simply pipe it to the console, but you can handle it in any way you'd normally handle a stream.

You might be asking, why do we require the polytest instance at the top here, rather than just putting them both in the same file? Well, you also will need to patch your test scripts so that polytest can work correctly, and the test script patch alsp requires the polytest instance.

Fortunately, it's a small and easy patch, just a single line. Here's an example:

```js
polytest = require('./path_to_above_example');
require = polytest.require();

// rest of your test file
```

> **NOTE**: One of our goals is to have you able to execute a file without polytest and still have it work correctly, even with the path. We have not yet completed this, so at the moment the patch will mess up the file when not run with polytest. We'll remove this note once this is no longer the case!

You will notice that polytest generates a directory at the root of your project to store the node modules according to the `package.json` that you pass to it. On the initialized polytest instance, the absolute path to this directory can be accessed via `polytest.path`. If you'd like to get rid of this directory, you can remove it using `polytest.remove_modules(callback)`. If you'd like to keep it, tests will still run and `polytest.install()` will simply update the dependencies when run. However, I'd advise adding `polytest_*` to your `.gitignore` file to make sure these folders are not pushed to git, much like you do with `node_modules`.

### License & Contributing

- Details on the license [can be found here](LICENSE.md)
- Details on running tests and contributing [can be found here](contributing.md)
