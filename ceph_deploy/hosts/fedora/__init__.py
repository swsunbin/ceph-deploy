import mon  # noqa
from ceph_deploy.hosts.centos import pkg  # noqa
from ceph_deploy.hosts.centos.install import repo_install  # noqa
from install import install, mirror_install  # noqa
from uninstall import uninstall  # noqa

# Allow to set some information about this distro
#

distro = None
release = None
codename = None
