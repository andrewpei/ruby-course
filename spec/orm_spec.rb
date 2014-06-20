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

end