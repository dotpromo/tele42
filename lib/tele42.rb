require 'logger'
require 'faraday'
require 'kconv'
require 'tele42/version'
require 'tele42/base'
require 'tele42/sms'

module Tele42
  extend self
  attr_accessor :debug, :username, :password, :server, :route, :callback_url
  attr_writer :user_agent, :logger

  # ensures the setup only gets run once
  @_ran_once = false

  def reset!
    @_ran_once = false
    @username = nil
    @password = nil
    @server = nil
    @route = nil
    @callback_url = nil
  end

  def user_agent
    @user_agent ||= "Tele42 v#{::Tele42::VERSION}"
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  reset!
end

#require 'nexmos/railties' if defined?(::Rails)
