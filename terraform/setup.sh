#!/bin/bash
asdf plugin add terraform # https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform 1.11.3
asdf set --home terraform 1.11.3
