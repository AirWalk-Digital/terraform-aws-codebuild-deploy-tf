# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/vishbhalla/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)
