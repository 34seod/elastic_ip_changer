require 'aws-sdk'

# config setting
Aws.config.update(
  region: 'us-west-2',
  credentials: Aws::Credentials.new("your access id", "your access password"),
)

# EC2 Client
ec2 = Aws::EC2::Client.new(region: 'us-west-2')

# current elastic ip
instance_id = "your ec2 instance id"
current_instance = ec2.describe_addresses({ filters: [{ name: "instance-id", values: [ instance_id ] }]}).addresses.first

# create elastic ip
new_elastic_ip = ec2.allocate_address({ domain: "vpc" })

# connect new elastic ip
associate_address_result = ec2.associate_address({
  allocation_id: new_elastic_ip.allocation_id,
  instance_id: instance_id,
})

# delete prev elastic ip
ec2.release_address({ allocation_id: current_instance.allocation_id })

# 新しい ip
p new_elastic_ip.public_ip
