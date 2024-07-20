class AddMessageToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :message, :text
  end
end
