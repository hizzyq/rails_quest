class AddUniqueIndexToAgentsCodename < ActiveRecord::Migration[8.1]
  def change
    # Добавляем if_not_exists: true в конец
    add_index :agents, :codename, unique: true, if_not_exists: true
  end
end
