class AddStatusToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :enabled?, :boolean, default: true
  end
end
