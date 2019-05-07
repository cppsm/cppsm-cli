# [≡](#contents) [C++ submodule manager command-line interface](#)

Poor man's submodule management, build scripts, and CI integration for simple,
"conventional" C++ libraries, executable tests, and executable programs on top
of

- [CMake](https://cmake.org/),
- [git](https://git-scm.com/),
- [Travis CI](https://travis-ci.org/), and
- [Codecov](https://codecov.io/).

The idea is to minimize boilerplate by relying on simple conventions over
excessive configuration. See also the
[C++ submodule manager boilerplate](https://github.com/cppsm/cppsm-boilerplate)
project.

[![Build Status](https://travis-ci.org/cppsm/cppsm-cli.svg?branch=master)](https://travis-ci.org/cppsm/cppsm-cli)
[![Code Coverage](https://img.shields.io/codecov/c/github/cppsm/cppsm-cli/master.svg)](https://codecov.io/github/cppsm/cppsm-cli?branch=master)

## <a id="contents"></a> [≡](#contents) [Contents](#contents)

- [Install](#install)
- [Synopsis](#synopsis)
- [Project structure](#project-structure)
- [Configuration](#configuration)
  - [`CODECOV`](#codecov)
  - [`XTRACE`](#xtrace)

## <a id="install"></a> [≡](#contents) [Install](#install)

Clone the `cppsm-cli` somewhere:

```bash
git clone https://github.com/cppsm/cppsm-cli.git
```

Add to your `.bash_profile`:

```bash
CPPSM="path to cppsm-cli directory"
export PATH="$CPPSM/bin:$PATH"
. "$CPPSM/bash_completion"
```

For the optional auto completion of git urls you must have both
[`curl`](https://curl.haxx.se/) and [`jq`](https://stedolan.github.io/jq/)
commands in path.

## <a id="synopsis"></a> [≡](#contents) [Synopsis](#synopsis)

Create a new project:

```bash
mkdir PROJECT && cd "$_"
git init
cppsm init
```

Try the hello world example (after `init`):

```bash
cppsm hello
cppsm test
.build*/internals/hello
```

Start hacking:

```bash
emacs internals/program/hello.cpp &
cppsm test-watch
```

Format project files inplace:

```bash
cppsm format
```

Clone an existing project:

```bash
cppsm clone URL BRANCH
```

Or clone an existing project using plain git:

```bash
git clone -b BRANCH URL/NAME.git
cd NAME
git submodule update --init     # NOTE: non-recursive
```

Add a required library:

```bash
cppsm add requires URL/NAME.git BRANCH
```

Remove a previously required library:

```bash
cppsm remove requires/NAME/BRANCH
```

Upgrade all required libraries:

```bash
cppsm upgrade
```

## <a id="project-structure"></a> [≡](#contents) [Project structure](#project-structure)

At the root of a project there are three directories as follows:

- The `equipment` directory may contain any number of _project submodules_ that
  the project internally depends upon.
- The `internals` directory may contain one or more _target directories_ that
  are internal to the project.
- The `provides` directory may contain one or more _target directories_ that are
  provided for dependant projects.
- The `requires` directory may contain any number of _project submodules_ that
  the provided targets depend upon.

In other words, both `internals` and `provides` may contain one or more target
directories. In case only a single `internal` or `provides` target directory is
needed, there is no need to create a nested directory.

A single _target directory_ may simultaneously contain

- a library in the `include/${name}` and `library` directories,
- an executable test in the `testing` directory, and
- an executable program in the `program` directory.

Try the `cppsm hello` script. It generates a simple example project that has
essentially the following structure:

    CMakeLists.txt
    equipment/
      testing.cpp/
        v1/
          provides/
            CMakeLists.txt
            include/
              testing_v1/
                test_synopsis.hpp
                test.hpp
            library/
              test.cpp
    internals/
      CMakeLists.txt
      testing/
        message_test.cpp
      program/
        hello.cpp
    provides/
      CMakeLists.txt
      include/
        message_v1/
          hello.hpp
      library/
        hello.cpp

Note that the include directories are versioned as are CMake target names and
C++ namespace names. This allows multiple major versions of a library to be used
simultaneously.

## <a id="configuration"></a> [≡](#contents) [Configuration](#configuration)

### <a id="codecov"></a> [≡](#contents) [`CODECOV`](#codecov)

By default the CI scripts do not generate and push code coverage results to
[Codecov](https://codecov.io/).  Set `CODECOV=1` to enable code coverage.

### <a id="xtrace"></a> [≡](#contents) [`XTRACE`](#xtrace)

By default the CI scripts do not `set -x` to enable Bash xtrace to avoid
unnecessary verbosity.  Set `XTRACE=1` to enable Bash xtrace.
