# Tele42 [![Build Status](https://travis-ci.org/dotpromo/tele42.png?branch=master)](https://travis-ci.org/dotpromo/tele42) [![Coverage Status](https://coveralls.io/repos/dotpromo/tele42/badge.png)](https://coveralls.io/r/dotpromo/tele42) [![Code Climate](https://codeclimate.com/github/dotpromo/tele42.png)](https://codeclimate.com/github/dotpromo/tele42)

42 Telecom HTTP SMS-MT API wrapper

## Installation

Add this line to your application's Gemfile:

    gem 'tele42'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tele42

## Usage


### Send text message

```ruby
# 42 Telecom specific client
client = ::Tele42::SMS.new({username: 'username', password: 'password', server: 'https://server1.msgtoolbox.com'})
# get result from 42 Telecom
id_of_sms_message = client.send_text(from: '1234567890', to: '1234567890', text: 'Hello world!')
```

## Ruby versions supporting

* 1.9.3
* 2.0.0
* Rubinius in 1.9 mode
* jRuby in 1.9 mode

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
