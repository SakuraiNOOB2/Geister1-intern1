module Errors
  class APIError < StandardError
    # @note override
    def status
      :internal_server_error
    end

    def id
      self.class.name.demodulize.underscore
    end
  end

  class RecordNotFound < APIError
    def status
      :bad_request
    end
  end

  class UnAuthorizedError < APIError
    def status
      :unauthorized
    end
  end

  class SessionExpiredError < APIError
    def status
      :unauthorized
    end
  end

  class FullHouseError < APIError
    def status
      :bad_request
    end
  end

  class InvalidRequestParameter < APIError
    def status
      :bad_request
    end
  end
end
