asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf install kubectl 1.21.13
asdf global kubectl 1.21.13

asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm 3.9.0
asdf global helm 3.9.0
helm plugin install https://github.com/databus23/helm-diff

asdf plugin add helmfile # https://github.com/feniix/asdf-helmfile.git
asdf install helmfile 0.144.0
asdf global helmfile 0.144.0