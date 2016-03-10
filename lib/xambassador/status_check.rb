module Xambassador
  # Status Check class
  class StatusCheck
    def initialize(connection, pull_request)
      @name = pull_request['base']['repo']['full_name']
      @sha = pull_request['head']['sha']
      @connection = connection
      @context = 'Default context'
      @description_pending = 'Pending'
      @description_success = 'Success'
      @description_failure = 'Failure'

      run(pull_request)
    end

    def run(pull_request)
    end

    def pending
      options = {
        context: @context,
        description: @description_pending
      }

      @connection.client.create_status(@name, @sha, 'pending', options)
    end

    def success
      options = {
        context: @context,
        description: @description_success
      }

      @connection.client.create_status(@name, @sha, 'success', options)
    end
  end
end
