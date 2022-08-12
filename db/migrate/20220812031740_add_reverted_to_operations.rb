class AddRevertedToOperations < ActiveRecord::Migration[7.0]
  def change
    add_column :operations, :reverted, :boolean, default: false
  end
end
