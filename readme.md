# xmonadrc 

## 安装

如果需要网速显示，需要通过`nmcli d`确认网络设备列表并写入`taffybar`的设置之中

### vscode 

只需要将预先设定在`.vscode`文件夹下的`task`启动即可(使用`ctrl+shift+b`)

当终端输出`-- set up over`表明编译完成可以使用

### shell

在`shell`环境下运行`script/buildUp.sh`以编译

## 编译环境

```shell
> xmonad --version
xmonad 0.13

> ghc --version
The Glorious Glasgow Haskell Compilation System, version 7.10.3

> cabal --version
cabal-install version 2.0.0.1
compiled using version 2.0.1.1 of the Cabal library 

> feh -v
feh version 2.14
Compile-time switches: curl exif xinerama

> hsetroot --version
hsetroot 1.0.2 - yet another wallpaper application

> xcompmgr --version
xcompmgr v1.1.7

> taffybar -v 0.4.5
```

## 桌面背景

~/.xmonad/background.jpg将被用作背景