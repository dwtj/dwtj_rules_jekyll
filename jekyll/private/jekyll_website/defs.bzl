'''Defines the `jekyll_website` rule.
'''

JekyllWebsiteInfo = provider(
    fields = {
        "srcs": "A `depset` of `File`s pointing to all of the source files that should be provided to `jekyll`.",
        "website_archive": "A `File` pointing to the output website archive built by this rule.",
    }
)

_JEKYLL_TOOLCHAIN_TYPE = "@dwtj_rules_jekyll//jekyll/toolchains/jekyll_toolchain:toolchain_type"

def _build_script_name(ctx):
    return ctx.attr.name + ".build.sh"

def _website_archive_name(ctx):
    return ctx.attr.name + ".tar.gz"

def _build_dir_name(ctx):
    return ctx.attr.name + ".jekyll_website"

def _extract_jekyll_exec(ctx):
    return ctx.toolchains[_JEKYLL_TOOLCHAIN_TYPE] \
              .jekyll_toolchain_info \
              .jekyll_exec

def _jekyll_website_impl(ctx):
    # Extract some information from the env for brevity.
    jekyll_exec = _extract_jekyll_exec(ctx)
    srcs = depset(direct = ctx.files.srcs)
    config_file = ctx.file.config

    # Declare some temporaries.
    build_script = ctx.actions.declare_file(_build_script_name(ctx))
    build_dir = ctx.actions.declare_directory(_build_dir_name(ctx))

    # Declare the output.
    website_archive = ctx.actions.declare_file(_website_archive_name(ctx))

    ctx.actions.expand_template(
        template = ctx.file._run_jekyll_build_script_template,
        output = build_script,
        substitutions = {
            "{JEKYLL_EXEC}": jekyll_exec.path,
            "{CONFIG_FILE}": config_file.path,
            "{WEBSITE_BUILD_DIR}": build_dir.path, 
            "{WEBSITE_ARCHIVE}": website_archive.path,
            "{WEBSITE_SOURCE_DIR}": ctx.attr.website_source_directory,
        },
    )

    ctx.actions.run(
        executable = build_script,
        inputs = depset(
            direct = [
                jekyll_exec,
                config_file,
            ],
            transitive = [
                srcs,
            ]
        ),
        outputs = [
            website_archive,
            build_dir,
        ],
        mnemonic = "JekyllBuild",
        progress_message = "Building and archiving Jekyll website `{}`".format(ctx.label),
    )

    return [
        DefaultInfo(files = depset([website_archive])),
        JekyllWebsiteInfo(
            srcs = srcs,
            website_archive = website_archive,
        )
    ]

jekyll_website = rule(
    implementation = _jekyll_website_impl,
    toolchains = [_JEKYLL_TOOLCHAIN_TYPE],
    # TODO(dwtj): Figure out how to specify/include a layouts directory. Should
    #  they be handled any differently from sources?
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "config": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        # TODO(dwtj): This is an ugly and ill-defined hack. Figure out how to do
        #  something better.
        "website_source_directory": attr.string(
            doc = "This is a path relative to the repository root.",
            mandatory = True,
        ),
        "_run_jekyll_build_script_template": attr.label(
            default = Label("@dwtj_rules_jekyll//jekyll:private/jekyll_website/TEMPLATE.run_jekyll_build.sh"),
            allow_single_file = True,
        ),
    }
)