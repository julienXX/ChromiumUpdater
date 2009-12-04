#!/bin/sh
# The macruby_deploy command-line tool with the --embed argument will make sure the MacRuby framework will be embedded in your .app. Default options will be used. Pass the -h option to get more information.
PATH="$PATH:/usr/local/bin" macruby_deploy --embed "$TARGET_BUILD_DIR/$PROJECT_NAME.app"
