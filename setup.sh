set -ex

cp user_gitignore ~/.gitignore
git config --global user.email gabrieldemarmiesse@gmail.com
git config --global user.name gabrieldemarmiesse
git config --global core.excludesfile ~/.gitignore
git config --global push.default upstream
git config --global pull.rebase false

curl -LsSf https://astral.sh/uv/install.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
curl -fsSL https://pixi.sh/install.sh | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/.zshrc

curl -fsSL https://claude.ai/install.sh | bash
nvm install 20
nvm use 20 && npm install -g @qwen-code/qwen-code@latest