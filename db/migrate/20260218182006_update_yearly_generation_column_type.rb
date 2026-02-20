class UpdateYearlyGenerationColumnType < ActiveRecord::Migration[8.0]
  def up
    change_column :yearly_generations, :generation_mwh, :decimal
  end

  def down
    change_column :yearly_generations, :generation_mwh, :integer
  end
end
