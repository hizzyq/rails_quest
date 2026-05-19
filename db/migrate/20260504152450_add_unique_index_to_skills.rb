class AddUniqueIndexToSkills < ActiveRecord::Migration[8.1]
  def change
    add_index :skills, :name, unique: true
  end
end
