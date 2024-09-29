# Problem description

This repository contains three identical modules, each with its own code, a sample application, and unit test targets.

Each module includes mixed Swift and Objective-C code, which is built using the [mixed_language_library rule](https://github.com/bazelbuild/rules_swift/pull/1293). Every module declares two classes: `Foo` (in Swift) and `Bar` (in Objective-C). The Objective-C code imports the Swift code via `#import <ModuleName/ModuleName-Swift.h>`. To make the Swift generated header accessible, I had to add `-I$(GENDIR)/Modules` to the copts as mentioned [here](https://bazelbuild.slack.com/archives/CD3QY5C2X/p1618987360069900) as well.

The module dependencies are the following:
- ModuleA sample app depends on ModuleC
- ModuleB depends on ModuleA
- ModuleC has no dependencies

The issue arises when building these modules sequentially. First, I build all targets of ModuleA by running:
```
cd Modules/ModuleA; bazel run xcodeproj -- --generator_output_groups=all_targets build
```

This works as expected.

However, when attempting the same with ModuleB, it fails with the following error:

```
Modules/ModuleB/Tests/Test.swift:1:8: error: missing required module 'ModuleC'
```

From my understanding this error occurs due to the way `-I` flags are ordered during the build. When building ModuleB's unit test target, Bazel picks up ModuleA's Example.swiftmodule instead of ModuleB's because `-I Modules/ModuleA` comes before `-I Modules/ModuleB`, causing the aforementioned error. Manually deleting the ModuleB/Example.swiftmodule or clearing Bazel's cache results in ModuleB building succeessfully.