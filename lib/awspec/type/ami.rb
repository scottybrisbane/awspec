module Awspec::Type
  class Ami < Base
    aws_resource Aws::EC2::Image

    def resource_via_client
      @resource_via_client ||= find_ami(@display_name)
    end

    def id
      @id ||= resource_via_client.image_id if resource_via_client
    end

    STATES = %w(
      pending available invalid deregistered
      transient failed error
    )

    STATES.each do |state|
      define_method state + '?' do
        resource_via_client.state == state
      end
    end
  end
end
