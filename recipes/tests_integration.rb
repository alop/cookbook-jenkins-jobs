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
