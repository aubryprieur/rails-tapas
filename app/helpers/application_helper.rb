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

    # Vérifier si Cloudinary est configuré
    if defined?(Cloudinary) && post.photo.service.is_a?(::ActiveStorage::Service::CloudinaryService)
      if is_zip
        cloudinary_url(post.photo.key, flags: "attachment", resource_type: "raw", format: "zip")
      else
        cloudinary_url(post.photo.key, flags: "attachment")
      end
    else
      # Fallback pour les uploads non-Cloudinary (local, S3, etc.)
      is_zip ? rails_blob_url(post.photo, disposition: :attachment) : url_for(post.photo)
    end
  end
end
