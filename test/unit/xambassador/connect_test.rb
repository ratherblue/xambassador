require 'xambassador/connect'

describe Xambassador::Connect do
  subject { Xambassador::Connect }

  it 'should return auth token' do
    subject.foo.must_equal('bar')
  end
end
