class AddSlugToEmployments < ActiveRecord::Migration[7.1]
  def change
    add_column :employments, :slug, :string
  end
end
