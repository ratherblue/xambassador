require "xambassador/connection"

describe Xambassador::Connection do
  subject { Xambassador::Connection }

  it "should have an auth token" do
    subject.new.token.wont_be_empty
  end
end
