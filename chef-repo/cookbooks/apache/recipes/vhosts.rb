data_bag("vhosts").each do |site|
	#|site| is the value from vhosts -- first bears and then second clowns -- these are defined under vhosts folder of data_bags
	site_data = data_bag_item("vhosts", site) # from vhosts get the first bears.json (data_bag_item) , second clowns.json
	site_name = site_data["id"] #get the id value from .json file
	document_root = "/srv/apache/#{site_name}" #declare a document root to place the vhosts files

#the template resource is used to manage the configurations on httpd server
	template "/etc/httpd/conf.d/#{site_name}.conf" do
		source "custom-vhosts.erb"
		mode "0644"
		# templates can accept a set of variables
		#variables from here can be sent down from recipes to templates for it to render
		variables(
        :document_root => document_root,
        :port => site_data["port"]
			)
		#notifies :action , "resource"
		notifies :restart, "service[httpd]"
	end

#document_root is the variable above
#directory resource is used to create directories for each vhosts
	directory document_root do
		mode "0755"
		recursive true # recursive keyword is used to create all the parent directories like mkdir -p 
	end

#template resource to render hompage for each vhosts
	template "#{document_root}/index.html" do
		source "index.html.erb"
		mode "0644"
		variables(
			:site_name => site_name,
			:port => site_data["port"]

		)
	end
end

 