class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :photo_id
      t.integer :author_id

      t.timestamps
    end
  end
end
