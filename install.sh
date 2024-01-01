#!/bin/bash

email="musasabi-7799@gmail.com"

cd "$(dirname "$0")" || exit
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b "${HOME}/.local/bin"
chezmoi init --promptString email="${email}" -S .
chezmoi apply -S .
