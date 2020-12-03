# Prompt Decorations
## kube-ps1

1. Download kube-ps1 from git (https://github.com/jonmosco/kube-ps1)
    ```
    git checkout git@github.com:jonmosco/kube-ps1.git ~/Documents/tools/kube-ps1
    ```
2. Import it into your prompt by adding the following line to your `~/.bashrc` and include it in your prompt
    ```
    source ~/Documents/kube-ps1/kube-ps1.sh
    ```

## kubectx
Not technically a prompt decoration but super useful when you have multiple k8s clusters

1. Download kubectx from git (https://github.com/ahmetb/kubectx) and add it to your PATH

## bash-git-prompt
1. Download bash-git-prompt from git (https://github.com/magicmonty/bash-git-prompt)
    ```
    git checkout git@github.com:magicmonty/bash-git-prompt.git ~/Documents/bash-git-prompt
    ```
2. Import it into your prompt by adding the following line to your `~/.bashrc` and include it in your prompt
    ```
    source ~/Documents/bash-git-prompt/gitprompt.sh
    ```

## git_profile
If you use multiple github accounts or other git accounts, I have a tool for that also

1. Download git_profile from git (https://github.com/fenfir/git_profile)
    ```
    git checkout git@github.com:fenfir/git_profile.git ~/Documents/git_profile
    ```
2. Import it into your prompt by adding the following line to your `~/.bashrc` and include it in your prompt
    ```
    source ~/Documents/git-profiles/git_profile.sh
    ```


# Adding it all Together
```
source <(kubectl completion bash)
source <(minikube completion bash)

source /home/zach/Documents/kube-ps1/kube-ps1.sh
source /home/zach/Documents/git-profiles/git_profile.sh

GIT_PROMPT_START='$(kube_ps1) $(git_profile)'

if [ "$color_prompt" = yes ]; then
    GIT_PROMPT_END='\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
else
    GIT_PROMPT_END='\n${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '
fi
unset color_prompt force_color_prompt

if [ -f "$HOME/Documents/bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=0
    source $HOME/Documents/bash-git-prompt/gitprompt.sh
fi
```
