# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/AirWalk-Digital/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)
