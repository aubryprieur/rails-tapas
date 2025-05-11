module ApplicationHelper
  def admin_types
    ['AdminUser']
  end

  def admin?
    admin_types.include?(current_user.type)
  end

  def cloudinary_download_url(key, options = {})
    # Construction directe de l'URL Cloudinary
    resource_type = options[:resource_type] || "image"
    format = options[:format]
    transformation = options[:transformation] || "fl_attachment"

    url = "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/#{resource_type}/upload/#{transformation}"
    url += "/#{key}"
    url += ".#{format}" if format

    url
  end
end
