# Description: Docker File for Welfare LTM

# Copyright (C) 2026 J.Cincotta
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
FROM debian:trixie-slim AS base
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Sydney/Australia

# Etc/UTC
RUN apt-get update > /dev/null
RUN apt-get install -yqq --fix-missing curl tini
RUN apt-get install -yqq --fix-missing debianutils
RUN apt-get install -yqq --fix-missing git wget bzip2 openssl build-essential libssl-dev
RUN apt-get install -yqq --fix-missing libpq-dev
RUN apt-get install -yqq --fix-missing libgl1 libglib2.0-0 
RUN apt-get install -yqq --fix-missing nodejs
RUN apt-get install -yqq --fix-missing python3 python3-pip python3-venv
RUN apt-get -yqq upgrade
# Burn the apt bridge...
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin/:$PATH"
RUN mkdir /project
RUN mkdir /project/data
WORKDIR /project
COPY pyproject.toml poetry.lock* ./
RUN poetry install --with dev --no-interaction --no-ansi
ENV PYTHONPATH=/project/
WORKDIR /project
ENTRYPOINT ["tini", "--"]
