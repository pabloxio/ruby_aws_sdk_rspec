# Ruby AWS SDK Client stubbing example with RSpec

This repo is an small example to demostrate how to add unit tests to your Ruby code with the AWS Ruby SDK. Part of my post [`Working with the AWS SDK for Ruby - Part II`](https://dev.to/pabloxio/working-with-the-aws-sdk-for-ruby-part-ii-cfh) on my [personal blog](https://dev.to/pabloxio).

## Requirements

- Ruby 2.7.2
- bundler '~> 2.2' (`gem install bundler -v '~> 2.2'`)

## Install

```bash
git clone git@github.com:pabloxio/ruby_aws_sdk_rspec
cd ruby_aws_sdk_rspec
bin/bundle install
Fetching gem metadata from https://rubygems.org/...
Using bundler 2.2.6
Fetching aws-partitions 1.418.0
Fetching aws-eventstream 1.1.0
Fetching jmespath 1.4.0
Fetching diff-lcs 1.4.4
Installing aws-eventstream 1.1.0
Installing jmespath 1.4.0
Installing aws-partitions 1.418.0
Installing diff-lcs 1.4.4
...
Installing aws-sdk-ec2 1.221.0
Bundle complete! 2 Gemfile dependencies, 13 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

## Code

`lib/list_ec2_instances.rb` contains a small Ruby class (`ListEC2Instances`) that has four methods to retrieve EC2 instances information using the `Aws::EC2::Client` (`#all_instances_using_client` and `#by_state_using_client`) and `Aws::EC2::Resource` (`#all_instances_using_resource` and `#by_state_using_resource`) classes from AWS Ruby SDK. All methods return an Array and each element contains a Hash with the instance_id and the instance state name:

You'll need [programmatic access](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) to an AWS account for the next steps:

```bash
bin/bundle exec irb -r ./lib/list_ec2_instances.rb
```
```ruby
2.7.2 :001 > list = ListEC2Instances.new
 => #<ListEC2Instances:0x00007fc0a1ab2ac0 @client=#<Aws::EC2::Client>, @resource=#<Aws::EC2::Resource:0x00007fc0a18fb4e8 @client=#<Aws::EC2::Client>>>
2.7.2 :002 > list.all_instances_using_client
 => [{:id=>"i-0b007c42dbf9fc300", :state=>"stopped"}]
2.7.2 :003 > list.all_instances_using_resource
 => [{:id=>"i-0b007c42dbf9fc300", :state=>"stopped"}]
2.7.2 :004 > list.by_state_using_client
 => []
2.7.2 :005 > list.by_state_using_client("stopped")
 => [{:id=>"i-0b007c42dbf9fc300", :state=>"stopped"}]
2.7.2 :006 > list.by_state_using_resource("stopped")
 => [{:id=>"i-0b007c42dbf9fc300", :state=>"stopped"}]
2.7.2 :007 >
```

## Tests

It's important to note that there is no need for AWS programmatic access because of EC2 client stubbing

```bash
bin/rspec

ListEC2Instances
  #all_instances_using_client
    should return nil without instances
    should return all instances
  #by_state_using_client
    should return only running instances
    should return only stopped instances
    should return empty list without stopping instances
  #all_instances_using_resource
    should return empty without instances
    should return all instances
  #by_state_using_resource
    should return only running instances
    should return only stopped instances
    should return empty list without stopping instances

Finished in 0.0778 seconds (files took 0.99912 seconds to load)
10 examples, 0 failures
```
