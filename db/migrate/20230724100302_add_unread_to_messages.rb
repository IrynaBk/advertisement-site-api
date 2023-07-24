class AddUnreadToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :unread, :boolean
  end
end
