class TM::Project
  attr_reader :name, :project_id

  def initialize(id, name)
    @name = name
    @project_id = id
  end

  # Need to be able to assign a user at task creation, currently if i try to pass in a value for user assigned it breaks because it won't take a nil.
  # def create_task(priority, description)
  #   task = TM.orm.create_task(description, @project_id, priority)
  #   return task
  # end

  # def remaining_tasks
  #   priority_hash = {
  #     "minor" => 1,
  #     "normal" => 2,
  #     "major" => 3,
  #     "critical" => 4,
  #     "blocker" => 5
  #   }
  #   return TM.orm.remaining_tasks(@project_id).sort { |task1, task2|
  #     if priority_hash[task1.priority] == priority_hash[task2.priority]
  #       (task1.creation_date > task2.creation_date) ? 1 : -1
  #     elsif priority_hash[task1.priority] < priority_hash[task2.priority]
  #       1
  #     elsif priority_hash[task1.priority] > priority_hash[task2.priority]
  #       -1
  #     end
  #   }
  # end

  # def finished_tasks
  #  # return @completed_tasks.values.sort # sorted by date created
  #  return TM.orm.finished_tasks(@project_id).sort { |task1, task2|
  #   (task1.completion_date > task2.completion_date) ? -1 : 1
  #  }
  # end

end
