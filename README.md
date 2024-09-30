# Problem description

This repository contains three identical modules, each with its own code, a sample application, and unit test targets.

The module dependencies are the following:
- ModuleA sample app depends on ModuleC
- ModuleB depends on ModuleA
- ModuleC has no dependencies

The issue arises when building these modules sequentially, running:

```
git clone https://github.com/tcamin/Bazel-iOS-Sandbox
cd Bazel-iOS-Sandbox
bazel build //Modules/ModuleA:Tests
bazel build //Modules/ModuleB:Tests
```

leads to a _Modules/ModuleB/Tests/Test.swift:1:8: error: missing required module 'ModuleC'_ error.


From my understanding this error occurs due to the way `-I` flags are ordered during the build. When building ModuleB's unit test target, Bazel picks up ModuleA's Example.swiftmodule instead of ModuleB's because `-I Modules/ModuleA` comes before `-I Modules/ModuleB`, causing the aforementioned error. Manually deleting the ModuleA/Example.swiftmodule or clearing Bazel's cache results in ModuleB building succeessfully.

