#
# Cookbook Name:: nodenv
# Provider:: node
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
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

include Chef::Nodenv::ScriptHelpers

def load_current_resource
  @rubie      = new_resource.definition
  @definition_file = new_resource.definition_file
  @root_path  = new_resource.root_path
  @user       = new_resource.user
  @environment = new_resource.environment
end

action :install do
  perform_install
end

action :reinstall do
  perform_install
end

private

def perform_install
  if node_build_missing?
    Chef::Log.warn(
      "node_build cookbook is missing. Please add to the run_list (Action will be skipped).")
  elsif node_installed?
    Chef::Log.debug("#{new_resource} is already installed - nothing to do")
  else
    install_start = Time.now

    Chef::Log.info("Building #{new_resource}, this could take a while...")

    # bypass block scoping issues
    nodenv_user    = @user
    rubie         = @rubie
    definition    = @definition_file || @rubie
    nodenv_prefix  = @root_path
    nodenv_env     = @environment
    command       = %{nodenv install #{definition}}

    nodenv_script "#{command} #{which_nodenv}" do
      code        command
      user        nodenv_user    if nodenv_user
      root_path   nodenv_prefix  if nodenv_prefix
      environment nodenv_env     if nodenv_env

      action      :nothing
    end.run_action(:run)

    Chef::Log.debug("#{new_resource} build time was " +
      "#{(Time.now - install_start)/60.0} minutes")

    new_resource.updated_by_last_action(true)
  end
end

def node_installed?
  if Array(new_resource.action).include?(:reinstall)
    false
  else
    ::File.directory?(::File.join(nodenv_root, 'versions', @rubie))
  end
end

def node_build_missing?
  ! run_context.loaded_recipe?("node_build")
end
