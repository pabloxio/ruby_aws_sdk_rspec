require 'list_ec2_instances'

RSpec.describe ListEC2Instances do
  let(:empty_client){ Aws::EC2::Client.new(stub_responses: true) }
  let(:full_client){
    client = Aws::EC2::Client.new(stub_responses: true)
    client.stub_responses(:describe_instances, {reservations: [
      instances: [
        {instance_id: "i-aaaaaaaaaaaaaaaaa", state: {name: "running"}},
        {instance_id: "i-bbbbbbbbbbbbbbbbb", state: {name: "running"}},
        {instance_id: "i-ccccccccccccccccc", state: {name: "stopped"}}
      ]
    ]})

    client
  }
  let(:empty_resource){ Aws::EC2::Resource.new(client: empty_client) }
  let(:full_resource){ Aws::EC2::Resource.new(client: full_client) }

  context "#all_instances_using_client" do
    it "should return empty list without instances" do
      list = ListEC2Instances.new({client: empty_client})
      result = list.all_instances_using_client

      expect(result).to be_empty
    end

    it "should return all instances" do
      list = ListEC2Instances.new({client: full_client})
      result = list.all_instances_using_client

      expect(result.size).to eq(3)
    end
  end

  context "#by_state_using_client" do
    it "should return only running instances" do
      list = ListEC2Instances.new({client: full_client})
      result = list.by_state_using_client

      expect(result.size).to eq(2)
    end

    it "should return only stopped instances" do
      list = ListEC2Instances.new({client: full_client})
      result = list.by_state_using_client("stopped")

      expect(result.size).to eq(1)
    end

    it "should return empty list without stopping instances" do
      list = ListEC2Instances.new({client: full_client})
      result = list.by_state_using_client("stopping")

      expect(result).to be_empty
    end
  end

  context "#all_instances_using_resource" do
    it "should return empty without instances" do
      list = ListEC2Instances.new({resource: empty_resource})
      result = list.all_instances_using_resource

      expect(result).to be_empty
    end

    it "should return all instances" do
      list = ListEC2Instances.new({resource: full_resource})
      result = list.all_instances_using_resource

      expect(result.size).to eq(3)
    end
  end

  context "#by_state_using_resource" do
    it "should return only running instances" do
      list = ListEC2Instances.new({resource: full_resource})
      result = list.by_state_using_resource

      expect(result.size).to eq(2)
    end

    it "should return only stopped instances" do
      list = ListEC2Instances.new({resource: full_resource})
      result = list.by_state_using_resource("stopped")

      expect(result.size).to eq(1)
    end

    it "should return empty list without stopping instances" do
      list = ListEC2Instances.new({resource: full_resource})
      result = list.by_state_using_resource("stopping")

      expect(result).to be_empty
    end
  end
end
