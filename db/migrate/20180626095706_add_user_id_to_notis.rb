class AddUserIdToNotis < ActiveRecord::Migration[5.1]
  def change
    add_column :notis, :user_id, :integer
    add_index :notis, :user_id
  end
end
