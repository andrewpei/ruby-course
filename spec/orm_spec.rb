require 'spec_helper'

describe 'ORM' do
  before(:all) do
    TM.orm.instance_variable_set(:@db_adapter, PG.connect(host: 'localhost', dbname: 'tm-db-test'))
    TM.orm.create_tables
  end

  before(:each) do
    TM.orm.delete_tables
    TM.orm.create_tables
    proj1 = TM.orm.add_project("do stuff")
  end

  after(:all) do
    TM.orm.delete_tables
  end

  it "is an ORM" do
    expect(TM.orm).to be_a(TM::ORM)
  end

  it "is created with a db adapter" do
    expect(TM.orm.db_adapter).not_to be_nil
  end

  it "adds a project to the DB" do
    expect(TM.orm.add_project("do stuff")).to be_a(TM::Project)
  end
  
  it "provides a list of projects, not in the right order necessarily" do
    proj1 = TM.orm.add_project("do stuff")
    proj2 = TM.orm.add_project("clean house")
    proj3 = TM.orm.add_project("buy milk")
    proj4 = TM.orm.add_project("refactor")
    result = TM.orm.list_projects
    proj_names = []
    result.each { |proj|
      proj_names << proj.name
    }
    expect(proj_names).to include("do stuff", "clean house", "buy milk", "refactor")
  end

  it "creates a task correctly" do
    task = TM.orm.create_task("finish hw", 1, "critical")
    expect(task).to be_a(TM::Task)
  end

  it "completes a task and sets the completion date" do
    task1 = TM.orm.create_task("do stuff", 1, "critical")
    task2 = TM.orm.create_task("buy milk", 1, "critical")
    task3 = TM.orm.create_task("pay strippers", 1, "blocker")
    task4 = TM.orm.create_task("do hw", 1, "major")
    completed_task1 = TM.orm.complete_task(1)
    completed_task3 = TM.orm.complete_task(3)
    expect(completed_task1.completion_date).to be_a(Time)
    expect(completed_task1.done).to eq('t')
  end

  it "returns a list of remaining tasks" do
    task1 = TM.orm.create_task("buy milk", 1, "critical")
    task2 = TM.orm.create_task("pay strippers", 1, "blocker")
    task3 = TM.orm.create_task("do hw", 1, "major")

    result = TM.orm.remaining_tasks(1)
    task_descs = []
    result.each { |task|
      task_descs << task.description
    }
    expect(task_descs).to include("pay strippers", "buy milk", "do hw")

  end

  it "returns a list of finished tasks" do
    task1 = TM.orm.create_task("do stuff", 1, "critical")
    task2 = TM.orm.create_task("buy milk", 1, "critical")
    task3 = TM.orm.create_task("pay strippers", 1, "blocker")
    task4 = TM.orm.create_task("do hw", 1, "major")
    TM.orm.complete_task(1)
    TM.orm.complete_task(3)
    TM.orm.complete_task(4)

    result = TM.orm.finished_tasks(1)
    tasks_done = []
    result.each { |task|
      tasks_done << task.description
    }
    # binding.pry
    expect(tasks_done).to include("pay strippers", "do stuff", "do hw")
  end

  it "creates an instance of the user class" do
    user = TM.orm.create_user("Bob")
    expect(user).to be_a(TM::User)
  end

  it "assigns a user to a project using the join table" do
    TM.orm.create_user("Bob")
    result = TM.orm.assign_to_proj(1, 1)
    # binding.pry
    expect(result).to include("1", "1", "1")
  end

  it "deletes a user from a project" do
    proj2 = TM.orm.add_project("clean house")
    TM.orm.create_user("Andrew")

    TM.orm.assign_to_proj(1, 1)
    TM.orm.assign_to_proj(1, 2)
    TM.orm.create_task("do stuff", 1, "critical")
    task = TM.orm.assign_task(1,1)
    expect(task.user_assigned).to eq(1)
    TM.orm.remove_user_from_proj(1,1)
    #I manually checked the result here for the user being removed but there is not auto test
  end

  it "returns the task object when you look it up" do
    TM.orm.create_task("do stuff", 1, "critical")
    TM.orm.create_task("homework", 1, "blocker")
    TM.orm.complete_task(1)
    task1 = TM.orm.task_lookup(1)
    task2 = TM.orm.task_lookup(2)
    expect(task1).to be_a(TM::Task)
  end

  it "assigns a task to a user correctly when they are part of the project" do
    TM.orm.add_project("clean house")
    TM.orm.create_user("Andrew")
    TM.orm.create_user("Jordan")
    TM.orm.assign_to_proj(1, 1)
    TM.orm.assign_to_proj(1, 2)
    TM.orm.assign_to_proj(2, 1)
    TM.orm.create_task("do stuff", 1, "critical")
    TM.orm.create_task("homework", 1, "blocker")
    TM.orm.create_task("pay strippers", 1, "major")
    TM.orm.create_task("buy clothes", 2, "minor")
    task = TM.orm.assign_task(1,1)
    # binding.pry
    expect(task.user_assigned).to eq(1)
  end

end