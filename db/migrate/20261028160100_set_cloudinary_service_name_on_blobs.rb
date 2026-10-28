# Les fichiers envoyés avant Rails 6.1 ont été enregistrés avec service_name = "local"
# alors qu'ils sont stockés sur Cloudinary. Jusqu'ici, un patch
# (config/initializers/active_storage_patch.rb) forçait "cloudinary" à la volée.
# Cette migration corrige les données une fois pour toutes, ce qui permet
# de supprimer le patch.
class SetCloudinaryServiceNameOnBlobs < ActiveRecord::Migration[8.1]
  def up
    return if Rails.env.test?

    execute <<~SQL
      UPDATE active_storage_blobs
      SET service_name = 'cloudinary'
      WHERE service_name IS NULL OR service_name <> 'cloudinary'
    SQL
    change_column_default :active_storage_blobs, :service_name, from: "local", to: nil
  end

  def down
    change_column_default :active_storage_blobs, :service_name, from: nil, to: "local"
  end
end
