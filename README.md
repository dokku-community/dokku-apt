dokku-apt
=========

Inject deb packages into dokku based on files in project.

dokku-apt is a plugin for [dokku][dokku] that installs apt packages in your dokku environment.
This is mostly useful for instances where you have an app that depends on packages being here.

## Installation

On your dokku server:

### dokku >= 0.4.0
```sh
sudo dokku plugin:install https://github.com/F4-Group/dokku-apt
```

### dokku < 0.4.0

```sh
git clone https://github.com/F4-Group/dokku-apt -b 0.3.0 /var/lib/dokku/plugins/dokku-apt
dokku plugins-install
```

## Usage

When you deploy your project, the dokku-apt plugin will install according to your project's `apt-repositories` and `apt-packages` files. You should store these files in your projects root as the docker container will copy your project to its /app directory. This is where the dokku-apt plugin looks for `apt-repositories` and `apt-packages`.

### apt-packages
This file should contain apt packages to install, accepts multiple packages per line, and multiple lines.

Example:
```
nginx
unifont
```

### apt-repositories
Optional file that should contain additional APT repositories to configure to find packages.
Requires an empty line at end of file.

Example:
```
ppa:nginx/stable
deb http://archive.ubuntu.com/ubuntu quantal multiverse
```

### apt-debconf
Optional file allowing to configure package installation. Use case is mainly for EULA (like ttf-mscorefonts-installer).
Requires an empty line at end of file.

Example:
```
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true
```

### dpkg-packages
Optional directory holding `.deb` packages to be installed automatically
after `apt-packages`, `apt-repositories` and `apt-debconf`. Allows the
installation of custom packages inside the container.

Example:

```
$ ls dpkg-packages/
your-package-0_0.0.1.deb
```

[dokku]: https://github.com/progrium/dokku
