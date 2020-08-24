load("@dwtj_rules_jekyll//jekyll:defs.bzl", "jekyll_website")
load("@dwtj_rules_markdown//markdown:defs.bzl", "markdown_library")

jekyll_website(
    name = "my_website",
    srcs = ["my_website/index.md"],
    config = "my_website/config.yml",
    website_source_directory = "my_website",
)

markdown_library(
    name = "some_markdown",
    srcs = ["my_website/index.md"],
)
