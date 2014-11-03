#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "httpd" do
 action :install # state of the package
end

service "httpd" do
	action [:enable, :start]
end

template "/var/www/html/index.html" do
	source "index.html.erb"
	mode "0644" # Permissions 
end

