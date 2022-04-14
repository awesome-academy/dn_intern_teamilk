module ApplicationHelper
  def full_title page_title
    base_title = t("base_title")
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def search_text
    return cookies[:content_flag] if cookies[:id_flag] == 1 &&
                                     cookies[:content_flag].present?

    t "shared.what_do_u_need"
  end

  include Pagy::Frontend
end
