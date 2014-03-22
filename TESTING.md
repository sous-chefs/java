This cookbook includes support for running tests via Test Kitchen. To get set up to test this cookbook:

Install the latest version of [Vagrant](http://www.vagrantup.com/downloads.html)

Install the latest version of [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (free) or [VMWare Fusion](http://www.vmware.com/products/fusion) (paid).

Clone the latest version of the cookbook from the repository.

    git clone git@github.com:socrata-cookbooks/java.git
    cd java

Install the gems used for testing:

    bundle install

Install the berkshelf plugin for vagrant:

    vagrant plugin install vagrant-berkshelf

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test

You can run a specific test only by specifying it on the command-line:

    kitchen test oracle-8-ubuntu-1204
    
Contributions to this cookbook will only be accepted if a full run of `kitchen test` completes successfully.
