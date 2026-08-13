asdf plugin add awscli
TARGET=$(asdf latest awscli)
asdf install awscli $TARGET
asdf set --home awscli $TARGET
