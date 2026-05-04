class AddUniqueIndexToAgentSkills < ActiveRecord::Migration[8.1]
  def change
    add_index :agent_skills, [:agent_id, :skill_id], unique: true
  end
end
