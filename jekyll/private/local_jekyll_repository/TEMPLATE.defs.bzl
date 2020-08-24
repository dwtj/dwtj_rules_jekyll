# This file was instantiated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

def register_jekyll_toolchain():
    native.register_toolchains(
        "@{REPOSITORY_NAME}//:jekyll_toolchain",
    )