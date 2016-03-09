require 'xambassador/connect'

describe Xambassador::Connect do
  subject { Xambassador::Connect }

  it 'should have an auth token' do
    subject.token.wont_be_empty
  end
end
