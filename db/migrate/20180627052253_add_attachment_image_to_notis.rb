class AddAttachmentImageToNotis < ActiveRecord::Migration[5.1]
  def self.up
    change_table :notis do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :notis, :image
  end
end
