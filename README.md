# zsh-config

Welcome to my full zsh configuration!

## Target audience

Anyone can use and modify my configurations in any way needed. I would only suggest that you 1) give me credit for something interesting you find here and 2) share your changes so other could benefit from it.

That being said I would like to point out that I work as a software engineer so most of my configurations are target for that kind of work.

## Installation

You can use this in any way you prefer but I would like to show you how I use it in my machines.

1. Clone this project into `~/.config/zsh`;
2. Change the `ZDOTDIR` to point to it;

Like this:

```sh
    $ mkdir -p ~/.config
    $ git clone https://github.com/Townk/zsh-config.git ~/.config/zsh
```

Now you need to tell ZSH how to find your ZSH configuration. This is where it can get confusing. Depending on the operating system you are, you should do a different thing.

### Linux

If you installed ZSH from yout distro packages, find out where the `zprofile` file is located. Some distros will use the same file as Bash, but I find out that some distros will put it at `/etc/zsh/zprofile`.

Assuming the the file is located at `/etc/zsh/zprofile`:

```sh
    $ sudo echo "export ZDOTDIR=~/.config/zsh" >> /etc/zsh/zprofile
```

### macOS

On _macOS_ things are a bit more complicated. The system does not use normal Unix artifacts to configure environment variable, and we have to rely on whatever _macOS_ provides.

To do so, we have to create a `launchctl` script and make sure it is executed when we login.

> **Note**: Although this approach works on most of the cases, when you restart
> the computer and ask it to re-open the opened applications, this `launchd`
> script will not be run before the OS start your previously opened terminals.
> In this case, simply restart all your terminals and  everything will work 
> again.

Create a `plist` file (the name you use is not important), add this content to it:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  <key>Label</key>
  <string>zshenv</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/launchctl</string>
    <string>setenv</string>
    <string>ZDOTDIR</string>
    <string>/Users/[your username]/.config/zsh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
```

And save it to `/Library/LaunchAgents/`.

Now you can logout and login again, or load your new script with:

``` sh
    $ launchctl load /Library/LaunchAgents/myvars.plist
```

### Non root or sudo access

If you want to install this ZSH config but you can't execut `sudo` commands, just link the `zshenv` file from this repo to `~/.zshenv`:

``` sh
    $ ln -sf ~/.config/zsh/zshenv ~/.zshenv
```

Also, if your user has Bash configure to it, you can still get ZSH without `sudo`. Link the `profile` file in this repository to `~/.profile`:

``` sh
    $ ln -sf ~/.config/zsh/profile ~/.profile
```
