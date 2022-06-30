class CreateCategoriesOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_operations, id: false do |t|
      t.references :category, null: false, foreign_key: true
      t.references :operation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
