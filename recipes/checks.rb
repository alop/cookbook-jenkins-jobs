#
# Cookbook Name:: jenkins-jobs
# Recipe:: checks
#
# Copyright 2012, Jay Pipes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

git_branch = 'master'
job_name = "check-chef-repo-#{git_branch}"

job_config = File.join(node[:jenkins][:server][:home], "#{job_name}-config.xml")

jenkins_job job_name do
  action :nothing
  config job_config
end

template job_config do
  source "check-chef-repo-config.xml"
  variables :job_name => job_name, :branch => git_branch, :node => node[:fqdn]
  notifies :update, resources(:jenkins_job => job_name), :immediately
  notifies :build, resources(:jenkins_job => job_name), :immediately
end

# Add ChefSpec testing jobs.
# TODO(jaypipes): If we ever want to upstream this cookbook, this
# list of cookbooks should be made into a node attribute
chef_spec_repos = [ "cookbook-networking", "cookbook-sol" ]

chef_spec_repos.each do |repo|
  test_job = "check-chef-spec-#{repo}")
  job_config = File.join(node[:jenkins][:server][:home], "#{test_job}-config.xml")

  jenkins_job test_job do
    action :nothing
    config job_config
  end

  template job_config do
    source "check-chef-spec-cookbook.xml.erb"
    variables :repo => repo
    notifies :update, resources(:jenkins_job => test_job), :immediately
    notifies :build, resources(:jenkins_job => test_job), :immediately
  end
  
end
