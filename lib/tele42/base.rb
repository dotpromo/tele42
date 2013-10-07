module Tele42
  class Base


    def initialize(options = {})
      parse_options(options)
      check_options
    end

    def parse_options(args)
      %w(username password server route).each do |k|
        ks = k.to_sym
        self.instance_variable_set("@#{k}".to_sym, args[ks] || ::Tele42.__send__(ks))
      end
    end

    def default_params
      @default_params ||= {
        'username' => @username,
        'password' => @password
      }
    end

    def check_options
      raise ::Tele42::InvalidUserName, 'username should be set' if @username.nil? || @username.empty?
      raise ::Tele42::InvalidPassword, 'password should be set' if @password.nil? || @password.empty?
      raise ::Tele42::InvalidServer,   'server should be set'   if @server.nil?   || @server.empty?
    end

    def server_url
      @server_url ||= begin
        if @server =~ /http/
          @server
        else
          "https://#{@server}"
        end
      end
    end

    def faraday_options
      {
        :url     => server_url,
        :headers => {
          :accept     => 'text/html',
          :user_agent => ::Tele42.user_agent
        }
      }
    end

    def connection
      @connection ||= Faraday::Connection.new(faraday_options) do |conn|
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
      end
    end
  end # Base
end # Tele42