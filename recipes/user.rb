#
# Cookbook Name:: nodenv
# Recipe:: user
#
# Copyright 2013, John Bellone
# Copyright 2010, 2011 Fletcher Nichol
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

include_recipe "nodenv::user_install"

Array(node['nodenv']['user_installs']).each do |nodenv_user|
  nodes    = nodenv_user['nodes'] || node['nodenv']['user_nodes']
  npm_hash  = nodenv_user['npms'] || node['nodenv']['user_npms']

  nodes.each do |node|
    if node.is_a?(Hash)
      nodenv_ruby "#{node} (#{nodenv_user['user']})" do
        definition  node
        user        nodenv_user['user']
        root_path   nodenv_user['root_path'] if nodenv_user['root_path']
        environment node['environment'] if node['environment']
      end
    else
      nodenv_ruby "#{node} (#{nodenv_user['user']})" do
        definition  node
        user        nodenv_user['user']
        root_path   nodenv_user['root_path'] if nodenv_user['root_path']
      end
    end
  end

  nodenv_global "#{nodenv_user['global']} (#{nodenv_user['user']})" do
    nodenv_version nodenv_user['global']
    user          nodenv_user['user']
    root_path     nodenv_user['root_path'] if nodenv_user['root_path']

    only_if     { nodenv_user['global'] }
  end

  npm_hash.each_pair do |node, npms|
    Array(npms).each do |npm|
      nodenv_npm "#{npm['name']} (#{nodenv_user['user']})" do
        package_name    npm['name']
        user            nodenv_user['user']
        root_path       nodenv_user['root_path'] if nodenv_user['root_path']
        nodenv_version   node

        %w{version action options source}.each do |attr|
          send(attr, npm[attr]) if npm[attr]
        end
      end
    end
  end
end
