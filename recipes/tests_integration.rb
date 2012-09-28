#
# Cookbook Name:: jenkins-jobs
# Recipe:: tests_integration
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

package "python-setuptools"

# We use pip in some of the testing jobs to install Python
# dependencies, so ensure the box running Jenkins has pip
execute "install_pip" do
    command "easy_install pip"
    user "root"
end

# Create the various test job configurations...
test_jobs = [ "test-subs-commands-single-node" ]

test_jobs.each do |test_job|

  job_config = File.join(node[:jenkins][:server][:home], "#{test_job}-config.xml")

  jenkins_job test_job do
    action :nothing
    config job_config
  end

  template job_config do
    source "#{test_job}.xml"
    variables :job_name => job_name 
    notifies :update, resources(:jenkins_job => job_name), :immediately
    notifies :build, resources(:jenkins_job => job_name), :immediately
  end
end
