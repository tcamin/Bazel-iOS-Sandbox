load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application", "ios_unit_test")
load("@build_bazel_rules_swift//mixed_language:mixed_language_library.bzl", "mixed_language_library")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
    "xcschemes",
)

deployment_target = "15.0"

def make_module(name, deps = [], sample_deps = []):
    """Instantiate everything needed to create a new network sub-module.

    Args:
        name: the name of the submodule
        deps: the dependencies of the submodule
        sample_deps: submodule's sample app dependencies
    """

    test_module_name = "{}Tests".format(name)
    test_files = native.glob(["Tests/**/*.swift"])

    test_action = None
    test_targets = []
    if len(test_files) > 0:
        test_targets.append("Tests")
        test_action = xcschemes.test(test_targets = test_targets)

    run_action = xcschemes.run(
        launch_target = "SampleApplication",
    )

    xcodeproj(
        name = "xcodeproj",
        project_name = name,
        xcschemes = [
            xcschemes.scheme(
                name = "Sample",
                run = run_action,
                test = test_action,
            ),
        ],
        tags = ["manual"],
        top_level_targets = [
            top_level_target(
                "SampleApplication",
                target_environments = ["simulator"],
            ),
        ] + test_targets,
    )

    ios_application(
        name = "SampleApplication",
        bundle_id = "com.example.app",
        families = [
            "iphone",
            "ipad",
        ],
        infoplists = ["Example/Info.plist"],
        minimum_os_version = deployment_target,
        visibility = ["@rules_xcodeproj//xcodeproj:generated"],
        deps = [":Example"],
    )

    if len(test_files) > 0:
        test_module_deps = [name, ":Example"]
        swift_library(
            name = test_module_name,
            testonly = True,
            srcs = test_files,
            deps = test_module_deps,
        )

        sample_app_deps = [test_module_name]
        ios_unit_test(
            name = "Tests",
            args = ["--command_line_args=-AppleLanguages,(en-GB)"],
            bundle_id = "com.example.app.test",
            features = ["apple.skip_codesign_simulator_bundles"],  # https://github.com/bazelbuild/rules_apple/blob/master/doc/common_info.md#codesign-bundles-for-the-simulator-appleskip_codesign_simulator_bundles
            minimum_os_version = deployment_target,
            tags = ["manual"],
            test_host = "SampleApplication",
            visibility = ["@rules_xcodeproj//xcodeproj:generated"],
            deps = sample_app_deps,
        )

    src_glob = native.glob(["Sources/**/*"])
    clang_srcs = [x for x in src_glob if x.endswith(".swift") == False]
    swift_srcs = [x for x in src_glob if x.endswith(".swift") == True]

    hdrs = native.glob(["Sources/**/*.h"])

    # Modules is not enabled if a custom module map is present even with
    # `enable_modules` set to `True`. This forcibly enables it.
    # See https://github.com/bazelbuild/bazel/blob/18d01e7f6d8a3f5b4b4487e9d61a6d4d0f74f33a/src/main/java/com/google/devtools/build/lib/rules/objc/CompilationSupport.java#L1280
    copts = [
        "-fmodules",
        "-I$(GENDIR)/Modules",
    ]

    mixed_language_library(
        name = name,
        module_name = name,
        clang_srcs = clang_srcs,
        swift_srcs = swift_srcs,
        enable_modules = True,
        visibility = ["//visibility:public"],
        hdrs = hdrs,
        features = ["swift.propagate_generated_module_map"],
        deps = deps,
        clang_copts = copts,
    )

    swift_library(
        name = "Example",
        module_name = "Example",
        data = native.glob(["Example/**/*.storyboard"]),
        srcs = native.glob(["Example/**/*.swift"]),
        deps = [":{}".format(name)] + sample_deps,
    )
