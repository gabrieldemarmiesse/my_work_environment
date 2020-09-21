# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
HISTFILE=/root/.zsh_history/all_history

alias gacp="git add . && git commit && git push"
alias bgacp="black ./ && git add . && git commit && git push"
alias ibgacp="isort ./ && black ./ && git add . && git commit && git push"
alias bfgacp="black ./ && flake8 && git add . && git commit && git push"
alias ibfgacp="isort ./ && black ./ && flake8 && git add . && git commit && git push"
alias sqd='date -u "+%Y%m%d%H%M%S"'
alias dc='docker-compose'
alias login_ecr='aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 766281746212.dkr.ecr.eu-west-1.amazonaws.com'
alias gac="git add . && git commit"
alias gcb="git checkout -b"
alias upload-to-pypi="rm -rf dist/ && python setup.py sdist && twine upload  --repository-url=https://upload.pypi.org/legacy/ dist/*"
alias docker-container-prune-all="docker kill $(docker ps  | grep -v 'gabriel_work_env' | awk 'NR>1 {print $1}')"

export E3_REPOS=/projects/dev-environment/projects
export E3_REPOSITORIES=/projects/work
export TF_VERSION=2.1.0
export PY_VERSION=3.5
export DOCKER_CLI_EXPERIMENTAL=enabled
export STORAGE_ROOT=/projects/work/storage_root
export SECRET_ENVS=/root/.secret_envs
export SECRETS_DIRECTORY=/root/.secret_envs
export E3_DEVELOPER_USERNAME=gabriel.demarmiesse
export COMPOSE_DOCKER_CLI_BUILD=1
export REGISTRY=766281746212.dkr.ecr.eu-west-1.amazonaws.com

function local_bdd() {
  export PGUSER=imagedb
  export PGPASSWORD=imagedb
  export PGHOST=localhost
  export PGDB=imagedb
  export PGPORT=5432
}

function gc() {
  git checkout "$1" && git pull
}

function my_du() {
  du -h --max-depth=1 $1
}

function squash_all() {
  git reset $(git merge-base master $(git rev-parse --abbrev-ref HEAD))
}

function reset_db() {
  docker run --rm -v dev-environment_postgres_persistence:/do -v /projects/work/backup_db/volume:/back busybox sh -c "rm -rf /do/* && cp -r /back/* /do/ && ls /do/"
}

function dump_to_csv() {
  local_bdd && psql -c "\\copy ${1}(${2}) TO './${1}.csv' DELIMITER ';' CSV HEADER"
}

function ssh-tunnel() {
  ssh -N -L  ${2}:127.0.0.1:${2} ${1}
}

function docker-cp() {
  id=$(docker create ${1})
  docker cp $id:${2} ${3}
  docker rm -v $id
}
