SHELL := /bin/bash
POETRY := poetry
# Description: Self documenting Makefile that has all the targets...
#
# Copyright (C) 2025 J.Cincotta
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
#


help: ## This help
	@echo "Beach Count"
	@echo "⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖⁖"
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

check-tools: ## Check tools are installed
	@command -v poetry

setup-local: check-tools  ## Set up local environment (for using an IDE during development)
	$(POETRY) install --with dev
	$(POETRY) run pre-commit install --install-hooks --overwrite

update-local: check-tools ## Update local dependencies
	$(POETRY) lock
	$(POETRY) install --with dev
	$(POETRY) run pre-commit install --install-hooks --overwrite

pre-commit: ## manually run pre-commit
	# $(POETRY) run pre-commit clean
	$(POETRY) run pre-commit run

pull: ## Pull Docker Images
	docker compose pull

build: ## Build Docker Environment
	export COMPOSE_BAKE=true;docker compose build beachcount

force-build: pull ## Force rebuild Docker Environment
	export COMPOSE_BAKE=true;docker compose build --no-cache --progress plain beachcount

run: ## Start Jupyter
	docker compose up

