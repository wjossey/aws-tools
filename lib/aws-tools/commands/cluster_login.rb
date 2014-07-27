module Commands
  class ClusterLogin
    include Commander::Methods

    def run
      command :"cluster-login" do |c|
        c.syntax = 'cluster-login'
        c.description = 'Login to clusters of servers'
        c.option '--facet STRING', String, 'Name of the facet you wish to login to.  Defaults to ALL instances'
        c.option '--batch INTEGER', Integer, 'The batch to login to.  Defaults to 0'
        c.option '--batch-size INTEGER', Integer, 'Only login to N servers. Defaults to 1,000'
        c.option '--username STRING', String, 'Username for SSH'
        c.option '--identity-file STRING', String, 'Path to the identity file'
        c.option '--security-groups ARRAY', Array, 'Array of security groups to include'
        c.action do |args, options|
          options.default :batch => 0, :batch_size => 10
          say_ok "Downloading server list from AWS... "
          server_list = {}
          filters = []
          if options.security_groups.present? && !options.security_groups.empty?
            filters = ["name" => "group-name", "values" => options.security_groups]
          end
          puts "Filters: #{filters}"
          server_list = $ec2.client.describe_instances(:filters => filters)[:instance_index]
          say_ok "Complete"

          count = 0
          say_ok "Determining target hosts... "
          target_servers = server_list.to_a.slice((options.batch * options.batch_size), options.batch_size)
          say_ok "Complete"
          say_ok "Targeting #{target_servers.count} servers from batch #{options.batch}"
          cmd = "csshX "
          ssh_args = " -o StrictHostKeyChecking=no "
          if options.username.present? && !options.username.blank?
            cmd += " --login #{options.username} "
          end
          if options.identity_file.present? && !options.identity_file.blank?
            ssh_args += " -i #{options.identity_file} "
          end
          cmd += " --ssh_args=\"#{ssh_args}\" "
          target_servers.each do |server|
            cmd += " #{server[1][:ip_address]} "
          end
          result = `#{cmd}`
          say_ok result
        end
      end
    end
  end
end
Commands::ClusterLogin.new.run
