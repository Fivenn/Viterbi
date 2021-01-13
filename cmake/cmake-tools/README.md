# CMake Tools

Some useful Cmake files and examples

* add as sub-module :

```bash
git submodule add ../../Tools/cmake-tools.git ./cmake/cmake-tools
ln -s ./cmake/cmake-tools/build.sh build.sh
```

* Add a git sub-module:

```bash
git submodule add ../<relative path>/<project>.git ./<install path>/<project>
```

* Init a git flow

```bash
git flow init --feature feature --hotfix hotfix --release release --defaults
```
