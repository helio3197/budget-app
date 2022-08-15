require 'utils/fetch_url'

class UtilsController < ApplicationController
  def fetch_image
    req = FetchUrl.new(params[:img])

    head(req.error_status) and return unless req.ok?

    send_data req.response.read_body, filename: 'img', type: req.response.content_type, disposition: 'inline'
  end
end
