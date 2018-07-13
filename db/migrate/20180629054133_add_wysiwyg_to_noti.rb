class AddWysiwygToNoti < ActiveRecord::Migration[5.1]
  def change
    add_column :notis, :wysiwyg, :text
  end
end
