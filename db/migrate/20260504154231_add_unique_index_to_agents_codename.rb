class AddUniqueIndexToAgentsCodename < ActiveRecord::Migration[8.1]
  def change
    add_index :agents, :codename, unique: true
  end
end