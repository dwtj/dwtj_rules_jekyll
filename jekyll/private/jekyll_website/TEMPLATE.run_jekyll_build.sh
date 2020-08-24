# This file was instantiated from a template with the following substitutions:
#
# - JEKYLL_EXEC: {JEKYLL_EXEC}
# - CONFIG_FILE: {CONFIG_FILE}
# - WEBSITE_SOURCE_DIR: {WEBSITE_SOURCE_DIR}
# - WEBSITE_BUILD_DIR: {WEBSITE_BUILD_DIR}
# - WEBSITE_ARCHIVE: {WEBSITE_ARCHIVE}

set -e

mkdir -p "{WEBSITE_BUILD_DIR}"

"{JEKYLL_EXEC}" build \
    --no-watch \
    --strict_front_matter \
    --config "{CONFIG_FILE}" \
    --source "{WEBSITE_SOURCE_DIR}" \
    --destination "{WEBSITE_BUILD_DIR}"

tar --create --gzip --file "{WEBSITE_ARCHIVE}" --directory "{WEBSITE_BUILD_DIR}" .

