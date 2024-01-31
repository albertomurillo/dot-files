# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

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

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.docker/bin"

# Configure Golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Configure HomeBrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_EDITOR=code

# update: Updates brew formulaes and casks
function update() {
  echo "Updating brew..."
  brew update

  echo "Updating brew apps..."
  brew upgrade

  echo "Updating cask apps..."
  for cask in $(brew outdated --cask --greedy --verbose | awk '$2 != "(latest)" {print $1}'); do
    brew reinstall --cask "$cask"
  done

  echo "Cleaning up brew..."
  brew doctor
  brew cleanup -s --prune=1
  rm -rf "$(brew --cache)"
}

# dr: Short for docker run but deletes container at exit
alias dr="docker run --rm -ti"

# di: Short for docker images but prints imageid first
alias di="docker images --format '{{.ID}}: {{.Repository}}:{{.Tag}}\t{{.CreatedSince}}\t{{.Size}}' | column -t -s $'\t'"

# docker_cleanup: Deletes unused images and containers
function docker_cleanup() {
  docker system prune -f
}

function docker_scan() {
  local IMAGE=$1
  trivy image --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed "${IMAGE}"
}

function docker_sha() {
  docker inspect "$1" | jq -r ".[].RepoDigests[]"
}

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# giturl: Open git repository in browser
function giturl() {
  local remote
  remote=$(git remote get-url origin)
  if [[ $remote =~ ^git:* ]]; then
    remote=${remote#git@}  # Remove git@
    remote=${remote%.git}  # Remove .git
    remote=${remote/://}   # Replace : with /
    remote=https://$remote # Convert to url
  fi
  open "$remote"
}

# kubectl pods
alias k='kubectl'
alias kg='kubectl get'
alias kgpod='kubectl get pod'
alias kgall='kubectl get all --all-namespaces'
alias kdp='kubectl describe pod'
alias kap='kubectl apply'
alias krm='kubectl delete'
alias krmf='kubectl delete -f'
alias kgsvc='kubectl get service'
alias kgdep='kubectl get deployments'
alias kl='kubectl logs'
alias kei='kubectl exec -it'

# Add zsh completion for kubectl
if [ -f /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# Add zsh completion for helm
#if [ -f /usr/local/bin/helm ]; then source <(helm completion zsh); fi

# kubesecret: Navigate kubernetes secrets easier
function kubesecret() {
  if [[ $# == 0 ]]; then
    kubectl get secrets
  elif [[ $# == 1 ]]; then
    kubectl get secrets "$1" -o json | jq -r .data
  elif [[ $# == 2 ]]; then
    output=$(kubectl get secrets "$1" -o json | jq -r .data.\""$2"\" | base64 -D)
    echo "$output"
  elif [[ $# == 3 ]]; then
    if [[ $3 == "-" ]]; then
      # If value is "-" delete the entry
      json=$(kubectl get secrets "$1" -o json | jq "del(.data.\"$2\")")
    else
      # Otherwise update the entry with a new value
      value=$(echo -n "$3" | base64)
      json=$(kubectl get secrets "$1" -o json | jq ".data.\"$2\" = \"$value\"")
    fi
    printf "%s" "$json" | kubectl apply -f -
  fi
}

# https://www.jeffgeerling.com/blog/2019/monitoring-kubernetes-cluster-utilization-and-capacity-poor-mans-way
function kube_usage() {
  if [ -n "$ZSH_VERSION" ]; then emulate -L ksh; fi
  local node_count=0
  local total_percent_cpu=0
  local total_percent_mem=0
  local readonly nodes=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name)

  for n in $nodes; do
    local requests=$(kubectl describe node $n | grep -A3 -E "\\s\sRequests" | tail -n2)
    local percent_cpu=$(echo $requests | awk -F "[()%]" '{print $2}')
    local percent_mem=$(echo $requests | awk -F "[()%]" '{print $8}')
    echo "$n: ${percent_cpu}% CPU, ${percent_mem}% memory"

    node_count=$((node_count + 1))
    total_percent_cpu=$((total_percent_cpu + percent_cpu))
    total_percent_mem=$((total_percent_mem + percent_mem))
  done

  local readonly avg_percent_cpu=$((total_percent_cpu / node_count))
  local readonly avg_percent_mem=$((total_percent_mem / node_count))

  echo "Average usage: ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
}

# sslexp: Show expiration date for a ssl certificate
function sslexp() {
  curl --insecure -v "https://$1" 2>&1 | awk 'BEGIN { cert=0 } /^\* Server certificate/ { cert=1 } /^\*/ { if (cert) print }'
}

# ssldomains: Print hostnames for a ssl certificate
function ssldomains() {
  nmap -p 443 --script ssl-cert "$1" | awk '/Alternative/ {print substr($0, index($0,$5))}' | tr "," \\n | tr -d " " | tr -d "DNS:"
}

# sslshow: Show ssl certificate from a site
function sslshow() {
  openssl s_client -connect $1:443 -servername $1
}

# sslshowlocal: Show ssl certificate from a file
function sslshowlocal() {
  openssl x509 -text -noout -in $1
}

function ssl_random_password() {
  openssl rand -base64 32
}

# akcurl: Curl bypassing akamai cache
function akcurl() {
  curl -i -D - -o /dev/null -s \
  -H "Pragma: X-Akamai-CacheTrack" \
  -H "Pragma: akamai-x-cache-on" \
  -H "Pragma: akamai-x-cache-remote-on" \
  -H "Pragma: akamai-x-check-cacheable" \
  -H "Pragma: akamai-x-feo-trace" \
  -H "Pragma: akamai-x-get-cache-key" \
  -H "Pragma: akamai-x-get-extracted-values" \
  -H "Pragma: akamai-x-get-nonces" \
  -H "Pragma: akamai-x-get-request-id" \
  -H "Pragma: akamai-x-get-ssl-client-session-id" \
  -H "Pragma: akamai-x-get-true-cache-key" \
  -H "Pragma: akamai-x-serial-no"
}

# unixtime: Converts unixtime to human readable date
function unixtime() {
  date -r $1
}

# Serve local directory over http
alias http_serve='python3 -m http.server 8080'
alias http_serve_nginx='docker run -p 8080:80 -v $(pwd):/usr/share/nginx/html:ro nginx'

# Beep
alias beep='echo -e "\a"'

# Linux sha256sum
function sha256sum() {
  shasum -a 256 $1
}

# AWS Console Output
function aws-console-output() {
  clear
  aws ec2 get-console-output --instance-id $1 --latest --output text
}

alias aws-ssh='aws ssm start-session --target'

function aws_list_asgs() {
  aws autoscaling describe-auto-scaling-groups \
    --output table \
    --query "AutoScalingGroups|[?contains(AutoScalingGroupName,\`$1\`)][AutoScalingGroupName]"
}

function aws_list_instances() {
  aws ec2 describe-instances \
    --output=table \
    --query "Reservations[].Instances[].{Name: Tags[?Key=='Name'] |[0].Value, InstanceId: InstanceId, InstanceType: InstanceType, ImageId: ImageId, State: State.Name, LaunchTime: LaunchTime, PrivateIpAddress: PrivateIpAddress}" \
    --filters "Name=tag:Name,Values=*$1*"
}

function aws_list_instances_tags() {
  aws ec2 describe-instances \
    --output=table \
    --query "Reservations[].Instances[].{Name: Tags[?Key=='Name']|[0].Value, InstanceId: InstanceId, InstanceType: InstanceType, ImageId: ImageId, State: State.Name}" \
    --filters "Name=metadata-options.instance-metadata-tags,Values=*$1*"
}

function aws_list_instances_by_asg() {
  aws ec2 describe-instances \
    --output=table \
    --query "Reservations[].Instances[].{Name: Tags[?Key=='Name']|[0].Value, InstanceId: InstanceId, InstanceType: InstanceType, ImageId: ImageId, State: State.Name}" \
    --filters "Name=tag:aws:autoscaling:groupName,Values=*$1*"
}

function aws_delete_instance() {
  aws ec2 terminate-instances --instance-ids $1
}

function aws_list_secrets() {
  cmd="aws secretsmanager list-secrets --output=table --query 'SecretList[][Name, KmsKeyId]'"
  if [ -n $1 ];
    then cmd="$cmd --filters \"Key=name,Values=$1\""
  fi
  eval $cmd
}

function aws_list_stacks() {
  # Filter has all states except "DELETE_COMPLETE
  FILTER='["REVIEW_IN_PROGRESS", "CREATE_FAILED", "UPDATE_ROLLBACK_FAILED", "UPDATE_ROLLBACK_IN_PROGRESS", "CREATE_IN_PROGRESS", "IMPORT_ROLLBACK_IN_PROGRESS", "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS", "ROLLBACK_IN_PROGRESS", "IMPORT_IN_PROGRESS", "UPDATE_COMPLETE", "UPDATE_IN_PROGRESS", "DELETE_FAILED", "IMPORT_COMPLETE", "DELETE_IN_PROGRESS", "ROLLBACK_COMPLETE", "ROLLBACK_FAILED", "IMPORT_ROLLBACK_COMPLETE", "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS", "CREATE_COMPLETE", "IMPORT_ROLLBACK_FAILED", "UPDATE_ROLLBACK_COMPLETE"]'
  KEYWORD=$1
  aws cloudformation list-stacks --output table --stack-status-filter $FILTER --query "StackSummaries|[?contains(StackName,\`$KEYWORD\`)][StackName,StackStatus]"
}

function aws_delete_stack() {
  aws cloudformation delete-stack --stack-name $1
}

function aws_delete_bucket() {
  python3 -c "import boto3; boto3.resource('s3').Bucket('$1').object_versions.all().delete()"
}

function aws_run_command() {
  set -ex
  asg=$1
  command=$2

  instances=$(aws ec2 describe-instances \
	--output=json \
	--filters "Name=tag:aws:autoscaling:groupName,Values=$asg" \
	--query "Reservations[].Instances[].InstanceId" \
	| jq -c)

  cmds=$(jq -c <<< [\"$command\"])

  sh_command_id=$(aws ssm send-command \
	--document-name "AWS-RunShellScript" \
	--targets "[{\"Key\":\"InstanceIds\",\"Values\": $instances}]" \
	--parameters commands="$cmds" \
	--output text --query "Command.CommandId")

  aws ssm list-command-invocations \
	--command-id $sh_command_id \
	--details \
	--query "CommandInvocations[].CommandPlugins[].{Status:Status,Output:Output}"
  set +ex
}

function aws_run_command_output() {
  command_id=$1
  aws ssm list-command-invocations \
    --command-id $command_id \
	  --details \
	  --query "CommandInvocations[].CommandPlugins[].{Status:Status,Output:Output}"
}

function aws-profile() {
  export AWS_PROFILE=$1
}

alias retry='while [ $? -ne 0 ] ; do fc -e "#"; done'
