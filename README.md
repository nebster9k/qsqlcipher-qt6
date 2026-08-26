## QSQLCipher-Qt6

This is a Qt6 plugin for [SQLCipher](https://www.zetetic.net/sqlcipher). Since SQLCipher is a drop-in replacement for SQLite, the Qt SQLite driver is
used as the base for this plugin.
The current implementation consists of
  * SQLCipher 4.18.0 (based on SQLite 3.53.4), amalgamation generated from https://github.com/sqlcipher/sqlcipher tag v4.18.0 (see `amalgamation/`)
  * libtomcrypt 1.18.2 from https://github.com/libtom/libtomcrypt
  * Qt SQLite plugin for Qt 6.8 and above, modified to compile with Qt 6.6 and sligthly changed so it can be loaded as separate plugin ("QSQLCIPHER")
  
## Compilation and Installation

You will need a Qt installation (e.g. installed through the [Qt Online installer](https://download.qt.io/official_releases/online_installers).
Clone this repository and set up the Qt environment.
  * cd <cloned QSQLCipher directory>
  * mkdir build
  * cd build
  * for MinGW: cmake ..\ -G "MinGW Makefiles"
  * for MSVC: cmake ..\ -G "NMake Makefiles"
  * for Linux: cmake ..\
  * cmake --build .
  * cmake --install .
For windows you have to build the debug and the release plugin (linked against the respective Qt library) by passing '-DCMAKE_BUILD_TYPE=Debug'
or '-DCMAKE_BUILD_TYPE=Release' to the first cmake call.
  
## Use within your Qt programm
Load the QSqlCipher plugin with [QSqlDatabase::addDatabase("QSQLCIPHER")](https://doc.qt.io/qt-6/qsqldatabase.html#addDatabase).

## About this fork

This is a fork of [chehrlic/qsqlcipher-qt6](https://github.com/chehrlic/qsqlcipher-qt6),
branched at commit `b3ee47e8eb551c987252eb8d05b446a330a6ad71`.

Changes against upstream:

* The bundled SQLCipher amalgamation is updated from 4.16.0 to 4.18.0.
* `CMakeLists.txt` no longer requests `SqlPrivate` as a `find_package` component.
  Some Qt installations do not ship a separate `Qt6SqlPrivate` package even
  though the `Qt6::SqlPrivate` target itself is available, which made the
  original build fail at configure time. The target is now looked up directly
  and the component is only requested as a fallback.
* Added `amalgamation/`, a Dockerfile and a shell script that build the
  SQLCipher amalgamation from source, so the bundled `sqlite3.c` / `sqlite3.h`
  can be regenerated for any SQLCipher tag without a local POSIX toolchain.

Tested with Qt 6.8.3 LTS (MinGW 13.1.0, Ninja).

### Regenerating the SQLCipher amalgamation

The `amalgamation/` directory contains a Dockerfile and `build_run.sh` that
clone SQLCipher at a given tag, run its build to produce the amalgamation, and
copy `sqlite3.c`, `sqlite3.h` and `sqlcipher.VERSION` into `amalgamation/out/`.
The generated version is verified against the requested tag before the files
are copied out.

    cd amalgamation
    ./build_run.sh v4.18.0

Copy the three resulting files over `3rdparty/sqlcipher/` and rebuild the
plugin. Remember to update the version string in `CMakeLists.txt` and in the
component list above.