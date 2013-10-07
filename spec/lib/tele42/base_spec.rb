require 'spec_helper'
describe ::Tele42::Base do
  before(:each) do
    ::Tele42.reset!
  end
  let(:options) { {username: 'a', password: 'b', server: 'c'} }
  subject { ::Tele42::Base.new(options) }
  context '#new' do
    it 'should call #parse_options and #check_options' do
      options = {'a' => 'b'}
      ::Tele42::Base.any_instance.should_receive(:parse_options).with(options)
      ::Tele42::Base.any_instance.should_receive(:check_options)
      ::Tele42::Base.new(options)
    end
    it 'should raise with invalid user name error' do
      expect { ::Tele42::Base.new({'a' => 'b'}) }.to raise_error(::Tele42::InvalidUserName)
    end
    it 'should raise with invalid password error' do
      expect { ::Tele42::Base.new(username: 'a') }.to raise_error(::Tele42::InvalidPassword)
    end
    it 'should raise with invalid server error' do
      expect { ::Tele42::Base.new(username: 'a', password: 'b') }.to raise_error(::Tele42::InvalidServer)
    end
    it 'should ser proper instance variables' do
      subject.instance_variable_get(:@username).should == 'a'
      subject.instance_variable_get(:@password).should == 'b'
      subject.instance_variable_get(:@server).should == 'c'
    end
  end
  its(:default_params) { should == {'username' => 'a', 'password' => 'b'} }
  its(:server_url) { should == 'https://c' }
  its(:faraday_options) { should == {url: 'https://c', headers: { accept: 'text/html', user_agent: "Tele42 v#{::Tele42::VERSION}" }} }
  its(:connection) { should be_a(::Faraday::Connection) }
  context '#connection' do
  end
end