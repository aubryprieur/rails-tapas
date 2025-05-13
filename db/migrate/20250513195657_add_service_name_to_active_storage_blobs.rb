class AddServiceNameToActiveStorageBlobs < ActiveRecord::Migration[6.1]
  def change
    add_column :active_storage_blobs, :service_name, :string
    change_column_default :active_storage_blobs, :service_name, "local"
  end
end
