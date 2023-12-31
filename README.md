# nvim_base
nvim in Docker

A docker compose version of the setup preconfigured with https://github.com/tjdevries neovim configs can
be ran with the following command:

```shell
$ docker compose -f docker-compose.yml up
```
the docker compose setup uses a few additional .env file variables:
   - `USER` is used for the linux user
   - `VIM_INSTALL_PATH` is used for the path where the config is placed
   - `VIM` is used for the path where neovim is built to
   - `VIMRUNTIME` is used for the nvim runtime path

sample.env
```
USER=david-engelmann
VIM=/home/david-engelmann/neovim
VIM_INSTALL_PATH=/home/david-engelmann/.config/nvim
VIMRUNTIME=/usr/share/nvim/runtime
```

Run with your code with the following command
```shell
$ docker run --pull=never --rm -v /path/to/config:${VIM_INSTALL_PATH} -v ${pwd}:${pwd} --user ${USER} vim-dev-env
```
