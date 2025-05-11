# Monkey patch pour ajouter la méthode service_name à ActiveStorage::Blob
module ActiveStorageBlobServiceNamePatch
  def service_name
    # Retourne un nom de service par défaut
    "local"
  end
end

# Applique le patch
Rails.application.config.to_prepare do
  ActiveStorage::Blob.include(ActiveStorageBlobServiceNamePatch)
end
