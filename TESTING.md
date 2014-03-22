Testing the java cookbook
=====

This cookbook includes both unit tests via [ChefSpec](https://github.com/sethvargo/chefspec) and integration tests via [Test Kitchen](https://github.com/test-kitchen/test-kitchen). Contributions to this cookbook will only be accepted if all tests pass successfully:

    kitchen test
    rspec

Setting up the test environment
-----

Install the latest version of [Vagrant](http://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (free) or [VMWare Fusion](http://www.vmware.com/products/fusion) (paid).

Clone the latest version of the cookbook from the repository.

    git clone git@github.com:socrata-cookbooks/java.git
    cd java

Install the gems used for testing:

    bundle install

Install the berkshelf plugin for vagrant:

    vagrant plugin install vagrant-berkshelf
    
Running ChefSpec
-----

ChefSpec unit tests are located in `spec`. Each recipe has a `recipename_spec.rb` file that contains unit tests for that recipe. Your new functionality or bug fix should have corresponding test coverage - if it's a change, make sure it doesn't introduce a regression (existing tests should pass). If it's a change or introduction of new functionality, add new tests as appropriate.

To run ChefSpec for the whole cookbook:

    rspec
    
To run ChefSpec for a specific recipe:

    rspec spec/set_java_home_spec.rb
    
Running Test Kitchen
-----

Test Kitchen test suites are defined in [.kitchen.yml](https://github.com/socrata-cookbooks/java/blob/master/.kitchen.yml). Running `kitchen test` will cause Test Kitchen to spin up each platform VM in turn, running the `java::default` recipe with differing parameters in order to test all possible combinations of platform, install_flavor, and JDK version. If the Chef run completes successfully, corresponding tests in `test/integration` are executed. These must also pass.
