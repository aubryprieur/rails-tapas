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
    transformation = options[:transformation] || attachment_flag(options[:filename])

    url = "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/#{resource_type}/upload/#{transformation}"
    url += "/#{key}"
    url += ".#{format}" if format

    url
  end

  private

  # "fl_attachment:Nom-du-fichier" : Cloudinary propose le téléchargement
  # sous ce nom (l'extension est ajoutée automatiquement) au lieu de la clé technique.
  def attachment_flag(filename)
    name = ActiveStorage::Filename.new(filename.to_s).base.parameterize(preserve_case: true) if filename.present?
    name.present? ? "fl_attachment:#{name}" : "fl_attachment"
  end
end
