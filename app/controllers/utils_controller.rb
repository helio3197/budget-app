class UtilsController < ApplicationController
  def fetch_image
    img_url = params[:img]

    if params[:img].nil? || !params[:img].match?(%r{\Ahttps?://(?:[\w-]+\.)?[\w-]+\.\w+(?:/.+)\z})
      head(:bad_request) and return
    end

    res = Net::HTTP.get_response(URI(img_url))

    head(:not_found) and return unless res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPOK)

    send_data res.read_body, filename: 'img', type: res.content_type, disposition: 'inline'
  end
end
