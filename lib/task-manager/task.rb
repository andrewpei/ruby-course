class TM::Task
  attr_reader :proj_id, :task_id, :creation_date
  attr_accessor :description, :status, :completion_date
  # Notable variables proj id, description, priority, completion status

  @@priority = {
    "minor" => 1,
    "normal" => 2,
    "major" => 3,
    "critical" => 4,
    "blocker" => 5
  }

  def initialize(proj_id, description, task_id, creation_date, priority)
    @creation_date = creation_date
    @proj_id = proj_id
    @description = description
    @priority = @@priority[priority]
    @task_id = task_id
    @status = :incomplete
  end

  def priority=(priority)
    @priority = @@priority[priority]
  end

  def priority
    @@priority.key(@priority)
  end

end
