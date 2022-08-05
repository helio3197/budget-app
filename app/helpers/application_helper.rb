module ApplicationHelper
  def current_path?(path)
    request.path == path
  end
end
