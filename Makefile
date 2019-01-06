# vim:ft=make:ts=8:sts=8:sw=8:noet:tw=80:nowrap:list

# My vars
_virtualenv=.venv


###
### tasks
###
.PHONY: help show init clean venv venv_help venv_clear tst test
.DEFAULT_GOAL:= help

help:   ## - Default: help/usage
	@echo
	@echo "Lambda: [${_lambda}]"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	    | awk 'BEGIN {FS = ":.*?## "}; {printf "  make \033[01;33m%-10s\033[0m %s\n", $$1, $$2}' \
	    # sort
	@echo

show:   ## - Show env vars
	@echo
	@echo "  Virtualenv: [${_virtualenv}]"
	@echo

init:   ## - Install from requirements.txt
	pip install -r requirements.txt
	pip install -r requirements-dev.txt

clean:
	find . -type d -name __py*cache__ -exec rm -rf {} \; 2>/dev/null
	find . -type f | egrep -i '.pyc|.pyb' | xargs rm
	rm -rf .pytest_cache

venv:   ## - Create virtualenv
	virtualenv ${_virtualenv}

venv_clear: ## - Clear (and reinstall) virtualenv
	@echo "Reinstalling..."
	virtualenv ${_virtualenv} --clear

venv_help: ## - Reminder...
	@echo
	@echo "source ${_virtualenv}/bin/activate"
	@echo

t1:     ## - Test: python ./...
	python ./mv-aws-slack-webhook.lambda.py

t2:     ## - Test: py.test -v
	@if [ -f ${_config_default} ]; \
	then   . ${_config_default} && pytest -v -s tests/ ; \
	else echo "Error: must define env vars in ${_config_default}"  ; \
	fi

act:	## - activate
	pyactivate

deact:	## - deactivate
	pydeactivate


