module Rack #:nodoc:
  class RequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env

      logger.debug "#{'*' * 20} Request Infomation #{'*' * 20}"

      output_headers
      output_parameters

      logger.debug '*' * 60

      @app.call(env)
    end

    private

    def request
      @request ||= Request.new(@env)
    end

    def output_headers
      logger.debug "Path: #{request.path}"
      logger.debug "Content-type: #{request.content_type}"
      logger.debug "method: #{@env['REQUEST_METHOD']}"
    end

    def output_parameters
      case @env['REQUEST_METHOD']
      when 'GET' then logger.debug "parameters: #{request.GET}"
      else
        begin
          logger.debug "parameters: #{JSON.parse(request.body&.string)}"
        rescue
          logger.debug "parameters: #{request.body&.string}"
        end
      end
    end

    def logger
      @logger ||= begin
        logger = ::Logger.new(STDOUT)
        logger.level = :debug
        logger
      end
    end
  end
end
