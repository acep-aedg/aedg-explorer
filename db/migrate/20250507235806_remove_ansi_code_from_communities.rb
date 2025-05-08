class RemoveAnsiCodeFromCommunities < ActiveRecord::Migration[8.0]
  def up
    remove_column :communities, :ansi_code, :string
  end

  def down
    add_column :communities, :ansi_code, :string
  end
end
