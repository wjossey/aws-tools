require 'openssl'
require 'commander/import'
require 'aws-sdk'
require 'aws-tools/commands/cluster_login'
require 'active_support/all'

class AWSTools
  $ec2 = AWS::EC2.new
  def run
    program :name, 'AWS-Tools'
    program :version, '0.0.1'
    program :description, 'AWS-Tools provides functionality on top of the aws-sdk'
  end
end
