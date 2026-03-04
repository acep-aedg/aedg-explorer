class CreateMonthlySales < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_sales do |t|
      t.references :reporting_entity, null: false, foreign_key: true
      t.integer :year
      t.integer :month
      t.integer :residential_revenue
      t.decimal :residential_sales
      t.integer :residential_customers
      t.integer :commercial_revenue
      t.decimal :commercial_sales
      t.integer :commercial_customers
      t.integer :industrial_revenue
      t.decimal :industrial_sales
      t.integer :industrial_customers
      t.integer :transportation_revenue
      t.decimal :transportation_sales
      t.integer :transportation_customers
      t.integer :community_revenue
      t.decimal :community_sales
      t.integer :community_customers
      t.decimal :government_sales
      t.integer :government_customers
      t.decimal :unbilled_sales
      t.integer :unbilled_customers
      t.integer :other_revenue
      t.decimal :other_sales
      t.integer :other_customers
      t.integer :total_revenue
      t.decimal :total_sales
      t.integer :total_customers
      t.string :source
      t.timestamps
    end
  end
end
