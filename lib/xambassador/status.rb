module Xambassador
  # Report status helpers
  class Status
    def initialize
    end

    def create
      @payload = JSON.parse(params[:payload])
    end
  end
end
