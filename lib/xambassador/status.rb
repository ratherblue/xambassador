# module Xambassador
#   # Report status helpers
#   class Status
#     def initialize
#       @connection = new
#     end
#
#     def create(name, status, options)
#       @client.create_status(pull_request['base']['repo']['full_name'],
#                             pull_request['head']['sha'], status, options)
#       @payload = JSON.parse(params[:payload])
#     end
#   end
# end
