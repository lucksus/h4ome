class AddHomeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :home_hash, :string
  end
end
