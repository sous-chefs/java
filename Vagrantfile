distros = {
  :lucid32 => {
    :url    => 'http://files.vagrantup.com/lucid32.box',
    :recipe => "openjdk",
    :run_list => [ "apt" ]
  },
  :centos6_32 => {
    :url      => 'http://vagrant.sensuapp.org/centos-6-i386.box',
    :recipe =>  "openjdk" 
  },
  :debian_squeeze_32 => {
    :url => 'http://mathie-vagrant-boxes.s3.amazonaws.com/debian_squeeze_32.box',
    :recipe => "openjdk",
    :run_list => [ "apt" ]
  },
  :precise32 => {
    :url => 'http://files.vagrantup.com/precise32.box',
    :recipe => "openjdk",
    :run_list => [ "apt" ]
  }
}

Vagrant::Config.run do |config|

  distros.each_pair do |name,options|
    config.vm.define name do |dist_config|
      dist_config.vm.box       = name.to_s
      dist_config.vm.box_url   = options[:url]
      
      dist_config.vm.customize do |vm|
        vm.name        = name.to_s
        vm.memory_size = 1024
      end

      dist_config.vm.network :bridged, '33.33.33.10'
      
      dist_config.vm.provision :chef_solo do |chef|

        chef.cookbooks_path    = [ '/tmp/cookbooks' ]
        chef.provisioning_path = '/etc/vagrant-chef'
        chef.log_level         = :debug

	
        chef.run_list = [
                         "minitest-handler",
                         "java::#{options[:recipe]}" 
                        ]
        if options[:run_list]
          options[:run_list].each {|recipe| chef.run_list.insert(0, recipe) }
        end

        chef.json = {
          java: {
            jdk_version: "6",
	    bin_cmds: [ "java", "jar", "jps", "jstack", "jstat" ],
            oracle: {
              accept_onerous_download_terms: true
            }
          }
        }
        
      end
    end
  end
end
