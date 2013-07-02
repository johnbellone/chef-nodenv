#
# Cookbook Name:: nodenv
# Recipe:: system
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

include_recipe "nodenv::system_install"

Array(node['nodenv']['nodes']).each do |node|
  if node.is_a?(Hash)
    nodenv_node node['name'] do
      environment node['environment'] if node['environment']
    end
  else
    nodenv_node node
  end
end

if node['nodenv']['global']
  nodenv_global node['nodenv']['global']
end

node['nodenv']['nodes'].each_pair do |node, gems|
  Array(gems).each do |npm|
    nodenv_npm npm['name'] do
      nodenv_version node

      %w{version action options source}.each do |attr|
        send(attr, npm[attr]) if npm[attr]
      end
    end
  end
end
