class ChangeBodyToTextInComments < ActiveRecord::Migration[8.0]
  def change
    change_column :comments, :body, :text
  end
end
