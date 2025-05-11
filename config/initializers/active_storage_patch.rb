# Monkey patch pour ajouter la méthode service_name à ActiveStorage::Blob
module ActiveStorageBlobServiceNamePatch
  def service_name
    # On retourne explicitement "cloudinary" pour compatibilité
    "cloudinary"
  end

  # En cas d'appel à certaines méthodes absentes
  def method_missing(method_name, *args, &block)
    if method_name.to_s == 'service' && respond_to?(:service_name)
      # Si quelqu'un appelle blob.service, on simule un service minimal
      OpenStruct.new(url_for: -> (key, **options) {
        "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/#{key}"
      })
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s == 'service' || super
  end
end

# Applique le patch
Rails.application.config.to_prepare do
  ActiveStorage::Blob.include(ActiveStorageBlobServiceNamePatch)
end
