module ApplicationHelper
  def current_path?(path)
    request.path == path
  end

  def max_pages(items_qty)
    (items_qty / params[:page_items].to_f).ceil
  end
end
