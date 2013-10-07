require 'spec_helper'
describe ::Tele42 do

  subject { ::Tele42 }

  before(:each) do
    subject.reset!
  end

  context '#reset!' do
    its(:user_agent) { should == "Tele42 v#{::Tele42::VERSION}" }
    its(:username) { should be_nil }
    its(:password) { should be_nil }
    its(:server) { should be_nil }
    its(:route) { should be_nil }
    its(:callback_url) { should be_nil }
    its(:logger) { should be_kind_of(::Logger) }
  end

  context '#setup' do

    context 'single call' do
      it 'should set user_agent' do
        subject.setup do |c|
          c.user_agent = 'Test1245'
        end
        subject.user_agent.should == 'Test1245'
      end

      it 'should set logger' do
        newlogger = ::Logger.new(STDERR)
        subject.setup do |c|
          c.logger = newlogger
        end
        subject.logger.should == newlogger
      end

      it 'should set username' do
        subject.setup do |c|
          c.username = 'username'
        end
        subject.username.should == 'username'
      end

      it 'should set password' do
        subject.setup do |c|
          c.password = 'password'
        end
        subject.password.should == 'password'
      end

      it 'should set server' do
        subject.setup do |c|
          c.server = 'server'
        end
        subject.server.should == 'server'
      end

      it 'should set route' do
        subject.setup do |c|
          c.route = 'route1'
        end
        subject.route.should == 'route1'
      end

      it 'should set callback_url' do
        subject.setup do |c|
          c.callback_url = 'http://example.com/'
        end
        subject.callback_url.should == 'http://example.com/'
      end

    end

    context 'double call' do
      it 'should not accept running setup more then once' do
        subject.setup do |c|
          c.username = 'user1'
        end
        subject.setup do |c|
          c.username = 'user2'
        end
        subject.username.should == 'user1'
      end
    end
  end

end