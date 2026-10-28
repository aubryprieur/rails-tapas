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

  # Lien de téléchargement Cloudinary de la pièce jointe d'un appel d'offres,
  # nommée « Client_Mission » (ex. : RIVP_Accompagnement-politique-de-la-ville.pdf).
  def post_attachment_download_url(post)
    filename = post.photo.blob.filename.to_s
    options = filename.downcase.ends_with?(".zip") ? { resource_type: "raw", format: "zip" } : {}
    options[:filename] = post_attachment_name(post).presence || filename
    cloudinary_download_url(post.photo.key, options)
  end

  private

  CLIENT_NAME_MAX = 30
  TITLE_NAME_MAX = 60

  def post_attachment_name(post)
    [
      shorten_for_filename(post.client, CLIENT_NAME_MAX),
      shorten_for_filename(post.title, TITLE_NAME_MAX)
    ].compact_blank.join("_")
  end

  # Supprime accents, espaces et caractères spéciaux, puis coupe entre deux mots.
  def shorten_for_filename(text, max)
    slug = text.to_s.parameterize(preserve_case: true)
    return slug if slug.length <= max

    cut = slug[0, max + 1]
    cut = cut.include?("-") ? cut.sub(/-[^-]*\z/, "") : cut[0, max]
    cut.delete_suffix("-")
  end

  # "fl_attachment:Nom-du-fichier" : Cloudinary propose le téléchargement
  # sous ce nom (l'extension est ajoutée automatiquement) au lieu de la clé technique.
  def attachment_flag(filename)
    name = ActiveStorage::Filename.new(filename.to_s).base.parameterize(preserve_case: true, separator: "-") if filename.present?
    name = name.to_s.gsub(/[^A-Za-z0-9_-]/, "")
    name.present? ? "fl_attachment:#{name}" : "fl_attachment"
  end
end
