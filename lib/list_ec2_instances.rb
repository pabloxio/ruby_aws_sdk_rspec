require 'aws-sdk-ec2'

class ListEC2Instances
  def initialize(params={})
    @client   = params[:client]   || Aws::EC2::Client.new
    @resource = params[:resource] || Aws::EC2::Resource.new(client: @client)
  end

  def all_instances_using_client
    @client.describe_instances.reservations&.first&.instances&.map do |i|
      {id: i.instance_id, state: i.state.name}
    end || []
  end

  def by_state_using_client(state="running")
    instances = @client.describe_instances.reservations&.first&.instances
    instances.select {|i| i.state.name == state}.map do |i|
      {id: i.instance_id, state: i.state.name}
    end
  end

  def all_instances_using_resource
    @resource.instances&.map do |i|
      {id: i.instance_id, state: i.state.name}
    end
  end

  def by_state_using_resource(state="running")
    instances = @resource.instances
    instances.select {|i| i.data.state.name == state}.map do |i|
      {id: i.data.instance_id, state: i.data.state.name}
    end
  end
end
