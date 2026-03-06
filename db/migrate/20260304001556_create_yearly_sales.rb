class CreateYearlySales < ActiveRecord::Migration[8.0]
  def change
    create_table :yearly_sales do |t|
      t.references :reporting_entity, null: false, foreign_key: true
      t.integer :year
      t.integer :residential_revenue
      t.decimal :residential_sales_mwh
      t.integer :residential_customers
      t.integer :commercial_revenue
      t.decimal :commercial_sales_mwh
      t.integer :commercial_customers
      t.integer :industrial_revenue
      t.decimal :industrial_sales_mwh
      t.integer :industrial_customers
      t.integer :transportation_revenue
      t.decimal :transportation_sales_mwh
      t.integer :transportation_customers
      t.integer :community_revenue
      t.decimal :community_sales_mwh
      t.integer :community_customers
      t.decimal :government_sales_mwh
      t.integer :government_customers
      t.decimal :unbilled_sales_mwh
      t.integer :unbilled_customers
      t.integer :other_revenue
      t.decimal :other_sales_mwh
      t.integer :other_customers
      t.integer :total_revenue
      t.decimal :total_sales_mwh
      t.integer :total_customers
      t.string :source
      t.timestamps
    end
  end
end
