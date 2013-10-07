require 'spec_helper'
describe ::Tele42::SMS do
  before(:each) do
    ::Tele42.reset!
  end
  let(:options) { {username: 'a', password: 'b', server: 'c', route: 'd'} }
  subject { ::Tele42::SMS.new(options) }
  context '#new' do
    it 'should call #check_route' do
      options = {'a' => 'b'}
      ::Tele42::SMS.any_instance.should_receive(:parse_options).with(options)
      ::Tele42::SMS.any_instance.should_receive(:check_options)
      ::Tele42::SMS.any_instance.should_receive(:check_route)
      ::Tele42::SMS.new(options)
    end
    it 'should raise with invalid route error' do
      expect { ::Tele42::SMS.new(username: 'a', password: 'b', server: 'c') }.to raise_error(::Tele42::InvalidRoute)
    end
  end
  its(:default_params) { should == {'username' => 'a', 'password' => 'b', 'route' => 'd'} }
  context '#send_text' do
    it 'should call #check_from' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "1,2,1", :headers => {})
      subject.should_receive(:check_from).with('12345678')
      subject.send_text(to: '1234567', from: '12345678', text: 'foobar')
    end
    it 'should call #generate_message_for' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "1,2,1", :headers => {})
      subject.should_receive(:generate_message_for).with(:text, 'foobar').and_call_original
      subject.send_text(to: '1234567', from: '12345678', text: 'foobar')
    end
    it 'should call #parse_result' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "1,2,1", :headers => {})
      subject.should_receive(:parse_result).and_call_original
      subject.send_text(to: '1234567', from: '12345678', text: 'foobar')
    end
    it 'should return proper sms message id' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "1,message_id,1", :headers => {})
      subject.send_text(to: '1234567', from: '12345678', text: 'foobar').should == 'message_id'
    end
    it 'should raise error BadLoginDetails' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "0,1", :headers => {})
      expect { subject.send_text(to: '1234567', from: '12345678', text: 'foobar') }.to raise_error(::Tele42::BadLoginDetails)
    end
    it 'should raise error BadMessage' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "0,2", :headers => {})
      expect { subject.send_text(to: '1234567', from: '12345678', text: 'foobar') }.to raise_error(::Tele42::BadMessage)
    end
    it 'should raise error BadNumber' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "0,3,12345678", :headers => {})
      expect { subject.send_text(to: '1234567', from: '12345678', text: 'foobar') }.to raise_error(::Tele42::BadNumber, 'Bad to number 12345678')
    end
    it 'should raise error NotEnoughCredits' do
      stub_request(:get, "https://c/api/current/send/message.php?from=12345678&message=foobar&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "0,4", :headers => {})
      expect { subject.send_text(to: '1234567', from: '12345678', text: 'foobar') }.to raise_error(::Tele42::NotEnoughCredits)
    end
    it 'should send sms in unicode variant' do
      stub_request(:get, "https://c/api/current/send/message.php?coding=unicode&from=12345678&message=00480065006C006C006F00200057006F0072006C0064&password=b&route=d&to=1234567&username=a").
               with(:headers => {'Accept'=>'text/html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Tele42 v0.0.1'}).
               to_return(:status => 200, :body => "1,nessage_id,1", :headers => {})
      subject.unicode!
      subject.send_text(to: '1234567', from: '12345678', text: 'Hello World')
    end
  end
end
