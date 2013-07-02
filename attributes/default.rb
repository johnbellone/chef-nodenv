#
# Cookbook Name:: nodenv
# Attributes:: default
#
# Author:: John Bellone <john.bellone.jr@gmail.com>
#
# Copyright 2013, John Bellone
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# git repository containing nodenv
default['nodenv']['git_url'] = "https://github.com/OiNutter/nodenv"
default['nodenv']['git_ref'] = "v0.1.0"

# upgrade action strategy
default['nodenv']['upgrade'] = "none"

# extra system-wide tunables
default['nodenv']['root_path'] = "/usr/local/nodenv"

# a list of user hashes, each an isolated per-user nodenv installation
default['nodenv']['user_installs'] = []

# list of additional rubies that will be installed
default['nodenv']['nodes']      = []
default['nodenv']['user_nodes'] = []

# hash of gems and their list of additional gems to be installed.
default['nodenv']['npm']      = Hash.new
default['nodenv']['user_npm'] = Hash.new

# whether to create profile.d shell script
default['nodenv']['create_profiled'] = true

case platform
when "redhat","centos","fedora", "amazon", "scientific"
  node.set['nodenv']['install_pkgs']   = %w{git grep}
  default['nodenv']['user_home_root']  = '/home'
when "debian","ubuntu","suse"
  node.set['nodenv']['install_pkgs']   = %w{git-core grep}
  default['nodenv']['user_home_root']  = '/home'
when "mac_os_x"
  node.set['nodenv']['install_pkgs']   = %w{git}
  default['nodenv']['user_home_root']  = '/Users'
when "freebsd"
  node.set['nodenv']['install_pkgs']   = %w{git}
  default['nodenv']['user_home_root']  = '/usr/home'
end
