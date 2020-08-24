# This file was instantiated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}
# - RULES_JEKYLL_REPOSITORY_NAME: {RULES_JEKYLL_REPOSITORY_NAME}
# - JEKYLL_LABEL: {JEKYLL_LABEL}

load("@{RULES_JEKYLL_REPOSITORY_NAME}//jekyll/toolchains/jekyll_toolchain:defs.bzl", "jekyll_toolchain")

jekyll_toolchain(
    name = "_jekyll_toolchain",
    jekyll = "{JEKYLL_LABEL}",
)

toolchain(
    name = "jekyll_toolchain",
    toolchain = ":_jekyll_toolchain",
    toolchain_type = "@{RULES_JEKYLL_REPOSITORY_NAME}//jekyll/toolchains/jekyll_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)
