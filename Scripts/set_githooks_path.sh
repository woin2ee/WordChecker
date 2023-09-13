#!/bin/sh

CURRENT_HOOKS_PATH=$(git config --get core.hooksPath)
PROJECT_HOOKS_PATH=".githooks"

if [ "${CURRENT_HOOKS_PATH}" != "${PROJECT_HOOKS_PATH}" ]; then
    git config core.hooksPath ${PROJECT_HOOKS_PATH}
fi
