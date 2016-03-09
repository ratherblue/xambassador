require 'xambassador/connect'

describe Xambassador::Connection do
  subject { Xambassador::Connection }

  it 'should have an auth token' do
    subject.token.wont_be_empty
  end
end
