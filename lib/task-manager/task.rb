class TM::Task
  attr_reader :proj_id, :task_id, :creation_date
  attr_accessor :description, :done, :completion_date

  @@priority = {
    "minor" => 1,
    "normal" => 2,
    "major" => 3,
    "critical" => 4,
    "blocker" => 5
  }

  def initialize(task_id, description, proj_id, priority, done, creation_date, completion_date)
    @creation_date = creation_date
    @proj_id = proj_id
    @description = description
    @priority = @@priority[priority]
    @task_id = task_id
    @done = done
    @completion_date = completion_date
  end

  def priority=(priority)
    @priority = @@priority[priority]
  end

  def priority
    @@priority.key(@priority)
  end

end