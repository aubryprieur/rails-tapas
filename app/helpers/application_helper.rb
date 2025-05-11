module ApplicationHelper
  def admin_types
    ['AdminUser']
  end

  def admin?
    admin_types.include?(current_user.type)
  end

  def download_link_for(post)
    return unless post.photo.attached?

    filename = post.photo.blob.filename.to_s
    is_zip = filename.downcase.ends_with?(".zip")

    # Utiliser une approche plus simple qui fonctionne avec tous les types de services
    begin
      if defined?(Cloudinary) && ENV['CLOUDINARY_URL'].present?
        # Si Cloudinary est configuré, utiliser cloudinary_url
        if is_zip
          cloudinary_url(post.photo.key, flags: "attachment", resource_type: "raw", format: "zip")
        else
          cloudinary_url(post.photo.key, flags: "attachment")
        end
      else
        # Fallback pour les uploads non-Cloudinary (local, S3, etc.)
        is_zip ? rails_blob_url(post.photo, disposition: :attachment) : url_for(post.photo)
      end
    rescue => e
      # En cas d'erreur, utiliser le fallback
      Rails.logger.error("Erreur lors de la génération du lien de téléchargement: #{e.message}")
      is_zip ? rails_blob_url(post.photo, disposition: :attachment) : url_for(post.photo)
    end
  end
end
