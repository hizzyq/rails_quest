class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
        Agent.order(:codename).pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.includes(:missions).order(:codename).map do |agent|
        missions = agent.missions.map(&:title).sort.join(", ")
        "#{agent.codename}: #{missions}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      # Подгружаем агентов и их миссии, чтобы избежать лишних запросов к БД
      agents = Agent.includes(:missions).to_a
      
      # Сортируем: сначала по количеству миссий (по убыванию), затем по имени (по возрастанию)
      sorted_agents = agents.sort_by { |agent| [-agent.missions.size, agent.codename] }
      
      sorted_agents.map do |agent|
        missions = agent.missions.map(&:title).sort.join(", ")
        "#{agent.codename} (#{agent.missions.size}): #{missions}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.includes(:skills).order(:codename).map do |agent|
        skills = agent.skills.map(&:name).sort.join(", ")
        "#{agent.codename}: #{skills}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      # Подгружаем все навыки и связанных с ними агентов
      skills = Skill.includes(:agents).to_a
      
      # Сортируем навыки: сначала по количеству агентов (по убыванию), затем по названию навыка
      sorted_skills = skills.sort_by { |skill| [-skill.agents.size, skill.name] }
      
      sorted_skills.map do |skill|
        # Получаем имена агентов, сортируем их по алфавиту и склеиваем через запятую
        agents = skill.agents.map(&:codename).sort.join(", ")
        "#{skill.name} (#{skill.agents.size}): #{agents}"
      end.join("\n")
    end
  end
end
