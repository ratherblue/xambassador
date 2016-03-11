require "json"
require "net/https"
require "uri"
require "renegade/branch_name"

require_relative "../status_check"

module Xambassador
  # Check peer review status
  class BranchName < StatusCheck
    def initialize(connection, pull_request)
      super(connection, pull_request, "Branch Name")

      branch_check = Renegade::BranchName.new
      @description_failure = branch_check.warning

      branch_name = pull_request['head']['ref']

      if branch_check.check_branch_name(branch_name)
        success
      else
        failure
      end
    end
  end
end
