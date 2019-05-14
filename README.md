dokku-apt
=========

Inject deb packages into dokku based on files in project.

dokku-apt is a plugin for [dokku](https://github.com/dokku/dokku) that installs apt packages in your dokku environment.
This is mostly useful for instances where you have an app that depends on packages being here.

## Installation

On your dokku server:

### dokku >= 0.4.0

```sh
sudo dokku plugin:install https://github.com/dokku-community/dokku-apt
```

## Usage

> This plugin only applies to buildpack-based applications. Users deploying via Dockerfile or Docker Image should customize those as appropriate.

When you deploy your project, the dokku-apt plugin will install according to your project's `apt-repositories` and `apt-packages` files. You should store these files in your projects root as the docker container will copy your project to its /app directory. This is where the dokku-apt plugin looks for `apt-repositories` and `apt-packages`.

The order of operations is:

1. `apt-sources-list`
2. `apt-repositories`
3. `apt-debconf`
4. `apt-packages`
5. `dpkg-packages`

### apt-sources-list
Overrides the `/etc/apt/sources.list` file. An empty file may be provided in order to remove upstream packages.

Example:
```
deb http://archive.ubuntu.com/ubuntu/ bionic main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-security main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main universe
deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
```

### apt-packages
This file should contain apt packages to install, accepts multiple packages per line, and multiple lines.

If this file is included, an `apt-get update` is triggered beforehand.

Example:
```
nginx
unifont
```

#### Specifying package versions

You can specify a package version with '=1.2.3' after the package name. 

Example:

```
libgd2-dev=2.1.1
```

### apt-repositories

Optional file that should contain additional APT repositories to configure to find packages.

If this file is included, an `apt-get update` is triggered, and the packages `software-properties-common` and `apt-transport-https` are installed. Both these actions happen before any repositories are added.

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

Packages are installed in lexicographical order. As such, if any packages depend upon one another, that dependency tree should be figured out beforehand.

Example:

```
$ ls dpkg-packages/
your-package-0_0.0.1.deb
```
