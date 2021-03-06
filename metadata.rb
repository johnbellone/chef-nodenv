name             "nodenv"
maintainer       "John Bellone"
maintainer_email "john.bellone.jr@gmail.com"
license          "Apache 2.0"
description      "Manages nodenv and its installed nodes. Several LWRPs are also defined."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md')) 
version          "0.1.0"

recommends "node_build"       # if using the nodenv_node LWRP, node-build must be installed

supports "ubuntu"
supports "debian"
supports "freebsd"
supports "redhat"
supports "centos"
supports "fedora"
supports "amazon"
supports "scientific"
supports "suse"
supports "mac_os_x"
