#
# Cookbook Name:: nodenv
# Recipe:: system_install
#
# Copyright 2013, John Bellone
# Copyright 2011, Fletcher Nichol
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

include_recipe 'nodenv'

upgrade_strategy  = build_upgrade_strategy(node['nodenv']['upgrade'])
git_url           = node['nodenv']['git_url']
git_ref           = node['nodenv']['git_ref']
nodenv_prefix     = node['nodenv']['root_path']

install_nodenv_pkg_prereqs

directory "/etc/profile.d" do
  owner   "root"
  mode    "0755"
end

template "/etc/profile.d/nodenv.sh" do
  source  "nodenv.sh.erb"
  owner   "root"
  mode    "0755"
end

install_or_upgrade_nodenv :nodenv_prefix => nodenv_prefix,
                          :git_url => git_url,
                          :git_ref => git_ref,
                          :upgrade_strategy => upgrade_strategy
