module Tele42
  class SMS < ::Tele42::Base

    def initialize(options = {})
      super(options)
      check_route
    end

    def check_route
      raise ::Tele42::InvalidRoute, 'route should be set' if @route.nil? || @route.empty?
    end

    def default_params
      @default_params ||= super.merge('route' => @route)
    end

    def unicode!
      @unicode = true
    end

    def send_text(options = {})
      from = options[:from]
      to = options[:to]
      message = options[:text]
      check_from(from)
      params = default_params.merge(
        'to' => to,
        'from' => from,
        'message' => generate_message_for(:text, message)
      )
      if @unicode
        params['coding'] = 'unicode'
      end
      res = connection.get('/api/current/send/message.php', params)
      parse_result(res)
    end

    def parse_result(res)
      data = res.body.split(',')
      if data[0].to_i == 1
        data[1]
      else
        parse_error(data)
      end
    end

    def parse_error(data)
      case data[1].to_i
      when 1
        raise ::Tele42::BadLoginDetails
      when 2
        raise ::Tele42::BadMessage
      when 3
        raise ::Tele42::BadNumber, "Bad to number #{data[2]}"
      when 4
        raise ::Tele42::NotEnoughCredits
      end
    end

    def generate_message_for(type, message)
      case type
      when :text
        generate_text_message(message)
      end
    end

    def generate_text_message(message)
      if @unicode
        if defined?(JRUBY_VERSION)
          message.each_byte.map { |b| sprintf('00%02X', b) }.join
        else
          ::Kconv.kconv(message, ::NKF::UTF16, ::NKF::UTF8).unpack('H*').first.upcase
        end
      else
        message.force_encoding('iso-8859-1')
      end
    end

    def check_from(from)
      unless from =~ /\A\d{1,15}\z/ || from =~ /\A[[:alnum:]]{1,11}\z/
        raise ::Tele42::InvalidFrom, 'invalid from format'
      end
    end

  end
end