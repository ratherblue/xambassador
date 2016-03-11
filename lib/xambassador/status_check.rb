module Xambassador
  # Status Check class
  class StatusCheck
    def initialize(connection, pull_request, context)
      @name = pull_request["base"]["repo"]["full_name"]
      @sha = pull_request["head"]["sha"]

      @connection = connection
      @context = context

      @description_pending = "Pending"
      @description_success = ""
      @description_failure = "Failure"
    end

    def pending
      options = {
        context: @context,
        description: @description_pending
      }

      @connection.client.create_status(@name, @sha, "pending", options)
    end

    def success
      options = {
        context: @context,
        description: @description_success
      }

      @connection.client.create_status(@name, @sha, "success", options)
    end

    def failure
      options = {
        context: @context,
        description: @description_failure
      }

      @connection.client.create_status(@name, @sha, "failure", options)
    end
  end
end
