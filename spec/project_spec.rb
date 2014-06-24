require 'spec_helper'

describe 'Project' do
 
  let(:project) {TM.orm.add_project("do stuff")}

  it "exists" do
    expect(project).to be_a(TM::Project)
  end

  # it "initializes a project and creates a task" do
  #   task = project.create_task("critical", "get shit done") # ask about quote handling
  #   expect(task).to be_a(TM::Task)
  # end

  # it "completes the task correctly" do
  #   task = project.create_task("critical", "get shit done")
  #   expect(task.done).to eq("f")
  #   TM.orm.complete_task(task.task_id)
  #   expect(TM.orm.task_lookup(task.task_id).done).to eq('t')
  # end

  # it "returns an array of tasks left sorted by priority > date when asked" do
  #   task1 = project.create_task("blocker", "learn ruby")
  #   task2 = project.create_task("critical", "get shit done")
  #   task3 = project.create_task("major", "10x coding")
  #   task4 = project.create_task("blocker", "buy milk")
  #   # sleep(1)
  #   task_id5 = project.create_task("blocker", "learn js")
  #   TM.orm.complete_task(task1.task_id)
  #   # binding.pry
  #   expect(project.remaining_tasks.size).to eq(4)
  # end

  # it "returns the array of finished tasks by creation date" do
  #   task1 = project.create_task("blocker", "get shit done")
  #   task2 = project.create_task("major", "10x coding")
  #   task3 = project.create_task("critical", "learn ruby")
  #   task4 = project.create_task("blocker", "learn js")
  #   TM.orm.complete_task(task1.task_id)
  #   # sleep(1)
  #   TM.orm.complete_task(task2.task_id)
  #   # sleep(1)
  #   TM.orm.complete_task(task3.task_id)
  #   # sleep(1)
  #   expect(project.finished_tasks.size).to eq(3)
  # end

end
