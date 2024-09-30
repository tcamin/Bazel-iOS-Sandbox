load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
    "xcschemes",
)

deployment_target = "15.0"

def make_module(name, deps = [], sample_deps = []):
    """Adds a new submodule to the project.

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

    swift_library(
        name = name,
        module_name = name,
        srcs = native.glob(["Sources/**/*.swift"]),
        visibility = ["//visibility:public"],
        features = ["swift.propagate_generated_module_map"],
        deps = deps,
    )

    swift_library(
        name = "Example",
        module_name = "Example",
        data = native.glob(["Example/**/*.storyboard"]),
        srcs = native.glob(["Example/**/*.swift"]),
        deps = [":{}".format(name)] + sample_deps,
    )
