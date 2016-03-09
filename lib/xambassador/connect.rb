module Xambassador
  # Connection helpers
  class Connect
    def self.token
      ENV['GITHUB_AUTH_TOKEN']
    end
  end
end
