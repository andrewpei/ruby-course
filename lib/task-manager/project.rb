class TM::Project
  attr_reader :name, :project_id
  attr_accessor :completed_tasks, :tasks_left


  def initialize(id, name)
    @name = name
    @proj_id = id
    @tasks_left, @completed_tasks = {}, {}
  end

  def create_task(priority, description)
    @tasks_left[@task_id] = TM::Task.new(@project_id, description, @task_id, Time.now, priority)
    @task_id += 1
    return (@task_id-1)
  end

  def complete_task(task_id)
    # binding.pry
    @tasks_left[task_id].status = :completed
    @tasks_left[task_id].completion_date = Time.now
    @completed_tasks[task_id] = @tasks_left[task_id]
    @tasks_left.delete(task_id)
  end

  def remaining_tasks
    priority_hash = {
      "minor" => 1,
      "normal" => 2,
      "major" => 3,
      "critical" => 4,
      "blocker" => 5
    }
    # binding.pry
    output = @tasks_left.values.sort { |task1, task2|
      # binding.pry
      if priority_hash[task1.priority] == priority_hash[task2.priority]
        (task1.creation_date > task2.creation_date) ? 1 : -1
      elsif priority_hash[task1.priority] < priority_hash[task2.priority]
        1
      elsif priority_hash[task1.priority] > priority_hash[task2.priority]
        -1
      end
    }
    # binding.pry
    return output
  end

  def finished_tasks
   # return @completed_tasks.values.sort # sorted by date created
   return @completed_tasks.values.sort { |task1, task2|
    (task1.completion_date > task2.completion_date) ? -1 : 1
   }
  end

end
