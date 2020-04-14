dokku-apt
=========

Inject deb packages into dokku based on files in project.

dokku-apt is a plugin for [dokku](https://github.com/dokku/dokku) that installs apt packages in your dokku environment.
This is mostly useful for instances where you have an app that depends on packages being here.

## requirements

dokku 0.18.x+
docker 1.8.x

## Installation

On your dokku server:

```sh
# on dokku 0.18.x+
sudo dokku plugin:install https://github.com/dokku-community/dokku-apt apt
```

## Usage

> This plugin only applies to buildpack-based applications. Users deploying via Dockerfile or Docker Image should customize those as appropriate.

When you deploy your project, the dokku-apt plugin will install according to your project's `apt-repositories` and `apt-packages` files. You should store these files in your projects root as the docker container will copy your project to its /app directory. This is where the dokku-apt plugin looks for `apt-repositories` and `apt-packages`.

The order of operations is:

1. `apt-conf`
2. `apt-env`
3. `apt-keys`
4. `apt-preferences`
5. `apt-sources-list`
6. `apt-repositories`
7. `apt-debconf`
8. `apt-packages`
9. `dpkg-packages`

Utilizing the above files, the base build image will be extended for further use in the build process. If an already extended app image that is compatible with the desired changes is found, then the above will be skipped in favor of using the pre-existing image.

Note that specifying packages within a `dpkg-packages` file will always bust the cache, as there is no way for the plugin to know if the files have changed between deploys.

### `apt-conf`

A config file for apt, as documented [here](https://linux.die.net/man/5/apt.conf). This is moved to the folder `/etc/apt/apt.conf.d/99dokku-apt`, and can override any `apt.conf` files that come before it in lexicographical order.

Example

```
Acquire::http::Proxy "http://user:password@proxy.example.com:8888/";
```

### `apt-env`

A file that can contain environment variables. Note that this is sourced, and should not contain arbitrary code.

Example

```
export ACCEPT_EULA=y
```

### `apt-keys`

> Usage of apt-keys without verifying the ownership of the key may result in compromising your apt infrastructure.

A file that can contain a list of urls for apt repository keys. Each one is installed via `curl "$KEY_URL" | apt-key add -`. Redirects are not followed. The `sha256sum` of the key contents will be displayed to allow for key verification.

Example

```
https://packages.microsoft.com/keys/microsoft.asc
```

### `apt-preferences`

A file that contains [APT Preferences](https://wiki.debian.org/AptPreferences). This file is not validated for correctness, and is installed to `/etc/apt/preferences.d/90customizations`.

Example:

```
APT {
  Install-Recommends "false";
}
```

### `apt-sources-list`

Overrides the `/etc/apt/sources.list` file. An empty file may be provided in order to remove upstream packages.

Example:
```
deb http://archive.ubuntu.com/ubuntu/ bionic main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-security main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main universe
deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
```

### `apt-packages`

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

### `apt-repositories`

Optional file that should contain additional APT repositories to configure to find packages.

If this file is included, an `apt-get update` is triggered, and the packages `software-properties-common` and `apt-transport-https` are installed. Both these actions happen before any repositories are added.

Requires an empty line at end of file.

Example:

```
ppa:nginx/stable
deb http://archive.ubuntu.com/ubuntu quantal multiverse
```

### `apt-debconf`

Optional file allowing to configure package installation. Use case is mainly for EULA (like ttf-mscorefonts-installer).
Requires an empty line at end of file.

Example:

```
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true
```

### `dpkg-packages`

Optional directory holding `.deb` packages to be installed automatically
after `apt-packages`, `apt-repositories` and `apt-debconf`. Allows the
installation of custom packages inside the container.

Packages are installed in lexicographical order. As such, if any packages depend upon one another, that dependency tree should be figured out beforehand.

Example:

```
$ ls dpkg-packages/
your-package-0_0.0.1.deb
```
