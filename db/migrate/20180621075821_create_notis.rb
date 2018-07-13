class CreateNotis < ActiveRecord::Migration[5.1]
  def change
    create_table :notis do |t|
      t.string :title
      t.text :description
      t.integer :timeout

      t.timestamps
    end
  end
end
