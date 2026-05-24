class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      # Прямой pluck делает ровно 1 легкий запрос: SELECT codename FROM agents ORDER BY codename
      Agent.order(:codename).pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      # Ровно 1 легкий запрос: SELECT title FROM missions ORDER BY title
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      # Извлекаем данные одним запросом с помощью джоина, не поднимая тяжелые объекты в память,
      # либо используем правильный обход ассоциации в Ruby.
      Agent.includes(:missions).order(:codename).map do |agent|
        # Использование .to_a гарантирует, что мы берем уже загруженный массив из памяти,
        # а не делаем SQL-запрос к ассоциации.
        missions = agent.missions.to_a.map(&:title).sort.join(", ")
        "#{agent.codename}: #{missions}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      # Подгружаем агентов и их миссии (всего 2 запроса к БД)
      agents = Agent.includes(:missions).to_a

      # Сортируем в памяти Ruby. size для предзагруженной ассоциации не делает новый запрос,
      # в отличие от count, который всегда фигачит SQL-запрос COUNT().
      sorted_agents = agents.sort_by { |agent| [-agent.missions.size, agent.codename] }

      sorted_agents.map do |agent|
        missions = agent.missions.to_a.map(&:title).sort.join(", ")
        "#{agent.codename} (#{agent.missions.size}): #{missions}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      # Загружаем агентов вместе с навыками
      Agent.includes(:skills).order(:codename).map do |agent|
        skills = agent.skills.to_a.map(&:name).sort.join(", ")
        "#{agent.codename}: #{skills}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      # Подгружаем все навыки и связанных с ними агентов (2 запроса)
      skills = Skill.includes(:agents).to_a

      # Сортируем навыки в памяти Ruby по количеству агентов и имени
      sorted_skills = skills.sort_by { |skill| [-skill.agents.size, skill.name] }

      sorted_skills.map do |skill|
        # .to_a предотвращает повторный SQL-вызов к таблице агентов
        agents_list = skill.agents.to_a.map(&:codename).sort.join(", ")
        "#{skill.name} (#{skill.agents.size}): #{agents_list}"
      end.join("\n")
    end
  end
end