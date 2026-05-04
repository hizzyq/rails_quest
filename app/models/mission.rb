class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true # <--- Возвращаем эту строку!

  enum :status, { assigned: "assigned", in_progress: "in_progress", completed: "completed" }
end