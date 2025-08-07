# Neovim

[Neovim](https://neovim.io/) is a Vim-fork focused on extensibility and usability.

[Github repository](https://github.com/neovim/neovim)

## Configuration

Base configuration is generated using [vim-bootstrap.com](https://vim-bootstrap.com/) and then patche files are created for each programming languages or frameworks. More customized configuration is created manually in `local_bundles.vim` and `local_init.vim`. To use the patch files, the key `let g:vim_bootstrap_langs` and `leg g:vim_bootstrap_frams` must be set to `""` first then the file patch is applied sequentially using command `patch -p 1 init.vim vim-bootstrap/<patch_name>.vim.patch`. To revert the patch, use the `*.revert` patch files, but it must be applied from the most recent patch first.

Use these steps to generate the patch files for specific programming language or framework. Firstly, generate vim configuration for the specific programming language or framework using vim-bootstrap.com and rename as `<programming language or framework>.vim`. Then, use these commands to generate the patch files.

```
cd vim-bootstrap
sed -Ei "s/let g:vim_bootstrap_langs = \".*\"/let g:vim_bootstrap_langs = \"\"/g" <config_name>.vim
sed -Ei "s/let g:vim_bootstrap_frams = \".*\"/let g:vim_bootstrap_frams = \"\"/g" <config_name>.vim
sed -Ei "s/^(\" vim-bootstrap).*$/\1/g" <config_name>.vim
diff -u init.vim <config_name>.vim > <config_name>.vim.patch
diff -u <config_name>.vim init.vim > <config_name>.vim.reverts
```

Make sure that the `init.vim` file that is used for generate patch file are the same as `init.vim.general`. We also use separate python environment for vim configuration.

```
python3 -m venv ~/.config/nvim/env
pip install pynvim
deactivate
```

Also install npm package for neovim, the command below is used when the node package is installed through package management system.

```
sudo npm install -g neovim
```

Install vim plugins using this command.

```
nvim +PlugInstall +qall
```

## Current configuration

The current configuration using the base configuration with these patches applied:

1. go
2. html
3. javascript
4. python
5. ruby
6. rust
7. typescript
8. vuejs

The current bootstrap keys

```
let g:vim_bootstrap_langs = "go,html,javascript,python,ruby,rust,typescript"
let g:vim_bootstrap_editor = "nvim"                             " nvim or vim
let g:vim_bootstrap_theme = "dracula"
let g:vim_bootstrap_frams = "vuejs"
```

## Configuration for Debian

Debian buster still provides neovim with version 0.3 which is not compatible with configuration generated from vim-bootstrap.com. We need to add the following changes to the vim configuration for Debian.

`init.vim`

```
" comment these configuration
"au TermEnter * setlocal scrolloff=0
"au TermLeave * setlocal scrolloff=3
```

`local_init.vim`

```
" disable rnvimr plugin
let g:rnvimr_ex_enable = 0

" disable go warning for neovim version
let g:go_version_warning = 0
```
