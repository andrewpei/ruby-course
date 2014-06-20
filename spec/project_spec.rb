require 'spec_helper'

describe 'Project' do

  let(:project) {TM::Project.new("Project Hello World")}

  it "exists" do
    expect(project).to be_a(TM::Project)
  end

  it "initializes a project and creates a task" do
    task_id = project.create_task("critical", "Let's get shit done")
    expect(project.tasks_left[task_id]).to be_a(TM::Task)
  end

  it "completes the task correctly" do
    task_id = project.create_task("critical", "Let's get shit done")
    expect(project.tasks_left.size).to eq(1)
    # binding.pry
    project.complete_task(task_id)
    # binding.pry
    expect(project.completed_tasks.size).to eq(1)
  end

  it "returns an array of tasks left sorted by priority > date when asked" do
    task_id1 = project.create_task("blocker", "learn ruby")
    task_id2 = project.create_task("critical", "Let's get shit done")
    task_id3 = project.create_task("major", "10x coding")
    task_id3 = project.create_task("blocker", "10x coding")
    sleep(1)
    task_id4 = project.create_task("blocker", "learn js")
    project.complete_task(1)
    # binding.pry
    expect(project.remaining_tasks.size).to eq(4)
  end

  it "returns the array of finished tasks by creation date" do
    task_id1 = project.create_task("blocker", "Let's get shit done")
    task_id2 = project.create_task("major", "10x coding")
    task_id3 = project.create_task("critical", "learn ruby")
    task_id4 = project.create_task("blocker", "learn js")
    project.complete_task(1)
    sleep(1)
    project.complete_task(3)
    sleep(1)
    project.complete_task(4)
    sleep(1)
    binding.pry
    expect(project.finished_tasks.size).to eq(3)
  end

end
