'''Defines the `jekyll_toolchain` rule. It is used to make toolchain instances.
'''

JekyllToolchainInfo = provider(
    fields = {
        "jekyll_exec": "A `File` pointing to a `jekyll` executable (in the host configuration)."
    }
)

def _jekyll_toolchain_impl(toolchain_ctx):
    toolchain_info = platform_common.ToolchainInfo(
        jekyll_toolchain_info = JekyllToolchainInfo(
            jekyll_exec = toolchain_ctx.file.jekyll,
        ),
    )
    return [toolchain_info]

jekyll_toolchain = rule(
    implementation = _jekyll_toolchain_impl,
    attrs = {
        "jekyll": attr.label(
            doc = "The `jekyll` executable (in the host configuration) to use to build Jekyll websites.",
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    },
)
