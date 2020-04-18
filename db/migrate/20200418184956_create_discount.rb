class CreateDiscount < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :min_quantity
      t.integer :percentage

      t.timestamps
    end
  end
end
