class AgentSkill < ApplicationRecord
  belongs_to :agent
  belongs_to :skill

  # Проверка, что у одного агента не может быть дважды добавлен один и тот же навык
  validates :agent_id, uniqueness: { scope: :skill_id }
end