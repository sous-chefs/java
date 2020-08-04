adoptopenjdk_install '8' do
  variant 'hotspot'
  url 'http://ftp.osuosl.org/pub/osl/sous-chefs/OpenJDK8U-jdk_x64_linux_hotspot_8u232b09.tar.gz'
  checksum '7b7884f2eb2ba2d47f4c0bf3bb1a2a95b73a3a7734bd47ebf9798483a7bcc423'
  default true
  alternatives_priority 1
end
