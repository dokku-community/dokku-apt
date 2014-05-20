dokku-apt
=========

Inject deb packages into dokku based on files in project.

dokku-apt is a plugin for [dokku][dokku] that installs apt packages in your dokku environment.
This is mostly useful for instances where you have an app that depends on packages being here.

## Installation

On your dokku server:
```sh
git clone https://github.com/F4-Group/dokku-apt /var/lib/dokku/plugins/dokku-apt
dokku plugins-install
```

All future deployments will read `apt-repositories` and `apt-packages` files and install them using `apt-get`.

## apt-packages
This file should contain apt packages to install, accepts multiple packages per line, and multiple lines.

## apt-repositories
Optional file that should contain additional ppa to configure to find packages.
Requires an empty line at end of file.

## apt-debconf
Optional file allowing to configure package installation. Use case is mainly for EULA (like ttf-mscorefonts-installer).
Requires an empty line at end of file.


[dokku]: https://github.com/progrium/dokku
