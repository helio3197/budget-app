class FetchUrl
  attr_reader :response

  def initialize(uri)
    if uri.match?(%r{\Ahttps?://(?:[\w-]+\.)?[\w-]+\.\w{2,3}(?:/.+)\z})
      @uri = URI(uri)
      @response = Net::HTTP.get_response(@uri)
    else
      @response = nil
    end
  end

  def ok?
    return false if @response.nil?

    @response.is_a?(Net::HTTPSuccess) || @response.is_a?(Net::HTTPOK)
  end

  def error_status
    return :bad_request if @response.nil?

    return :not_found unless ok?

    nil
  end
end
