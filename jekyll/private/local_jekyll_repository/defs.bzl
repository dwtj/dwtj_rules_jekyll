'''Defines the `local_jekyll_repository` repository rule.
'''

_JEKYLL_SYMLINK_NAME = "jekyll"

def _local_jekyll_repository_impl(repository_ctx):
    jekyll_path = repository_ctx.which('jekyll')
    if jekyll_path == None:
        fail("Failed to find a `jekyll` executable on the system `PATH`. Could not initialize `local_jekyll_repository` `{}`".format(repository_ctx.name))

    repository_ctx.symlink(jekyll_path, _JEKYLL_SYMLINK_NAME)

    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{RULES_JEKYLL_REPOSITORY_NAME}": "dwtj_rules_jekyll",
            "{JEKYLL_LABEL}": ":" + _JEKYLL_SYMLINK_NAME,
        },
        executable = False,
    )

    repository_ctx.template(
        "defs.bzl",
        repository_ctx.attr._defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{RULES_JEKYLL_REPOSITORY_NAME}": "dwtj_rules_jekyll"
        },
        executable = False,
    )

    # TODO(dwtj): Figure out how the return value ought to be set.
    return None

local_jekyll_repository = repository_rule(
    doc = "Searches the system `PATH` for a `jekyll` executable. If it is not found, then this rule fail. If it is found, then this executable is symlinked into the root of this external repository. Additionally, a `jekyll_toolchain` (labeled `//jekyll_toolchain`) is synthesized in the root package of this external repository to wrap this executable symlink. This toolchain can be registered with the helper macro `//:defs.bzl%register_jekyll_toolchain`.",
    attrs = {
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_jekyll//jekyll:private/local_jekyll_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_jekyll//jekyll:private/local_jekyll_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    },
    implementation = _local_jekyll_repository_impl,
    environ = [
        # This rule is sensitive to changes to `PATH` because it searches `PATH`
        # to find a `jekyll` executable.
        "PATH",
    ],
    local = True,
)
