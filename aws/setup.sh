asdf plugin add awscli
TARGET=$(asdf latest awscli)
asdf install awscli $TARGET
asdf global  awscli $TARGET
