class UtilsController < ApplicationController
  def fetch_image
    img_url = params[:img]

    res = Net::HTTP.get_response(URI(img_url))

    send_data res.read_body, filename: 'img', type: res.content_type, disposition: 'inline'
  end
end
