#
# **************************************************************
# *                                                            *
# * Author: sunbin (2023)                                      *
# * URL: https://github.com/ceph/ceph-deploy				   		   *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of this C++ Makefile template is permitted under  *
# * the guidelines and in accordance with the the MIT License  *
# * http://www.opensource.org/licenses/MIT                     *
# *                                                            *
# **************************************************************
#

TOPDIR := $(shell /bin/pwd)
core_src_dir = $(TOPDIR)
build_dir = $(TOPDIR)/build
ceph_deploy_src_dir = $(core_src_dir)/ceph-deploy-2.1.0
ceph_deploy_dest_dir = $(build_dir)/SOURCES/ceph-deploy-2.1.0
boost_src_dir = $(TOPDIR)/boost
ceph_deploy = ceph-deploy-2.1.0
all:  .build_ceph_deploy
  
.build_ceph_deploy:
	@(if [ -d $(build_dir) ]; then rm -rf $(build_dir); fi)
	@(mkdir -p $(build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(if [ -d $(ceph_deploy_dest_dir) ]; then mkdir -p $(ceph_deploy_dest_dir); fi)

	@echo "---------- copy ceph-deploy files ----------"
	@cp -a $(ceph_deploy_src_dir) $(ceph_deploy_dest_dir)
	@(cd $(build_dir)/SOURCES; \
		rm -rf $(ceph_deploy)/.git; \
		tar -jcvf $(ceph_deploy).tar.bz2 $(ceph_deploy); \
		rm -rf $(ceph_deploy))

	@echo "---------- copy spec ----------"
	@(cp -af $(core_src_dir)/ceph-deploy.spec $(build_dir)/SPECS/)

	@echo "---------- build ceph-deploy ----------"
	@(rpmbuild -ba --define="_topdir $(build_dir)" $(build_dir)/SPECS/ceph-deploy.spec)

install:
	@(cd $(build_dir)/RPMS/noarch; rpm -vih *.noarch.rpm --force)
	@(cd $(build_dir)/RPMS/x86_64; rpm -vih *.x86_64.rpm --force)
clean:
	-rm -rf $(build_dir)