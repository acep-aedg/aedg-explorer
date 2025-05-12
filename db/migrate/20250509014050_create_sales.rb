class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :reporting_entity, null: false, foreign_key: true
      t.integer :year
      t.integer :residential_revenue
      t.integer :residential_sales
      t.integer :residential_customers
      t.integer :commercial_revenue
      t.integer :commercial_sales
      t.integer :commercial_customers
      t.integer :total_revenue
      t.integer :total_sales
      t.integer :total_customers

      t.timestamps
    end
  end
end
