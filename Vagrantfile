distros = {
  :lucid32 => {
    :url      => 'http://files.vagrantup.com/lucid32.box'
  },
  :centos6_32 => {
    :url      => 'http://vagrant.sensuapp.org/centos-6-i386.box'
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
                         "java::oracle" 
                        ]
        
        chef.json = {
          java: {
            jdk_version: "6",
            oracle: {
              accept_onerous_download_terms: true
            }
          }
        }
        
      end
    end
  end
end
