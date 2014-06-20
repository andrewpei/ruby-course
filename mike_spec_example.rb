require 'spec_helper'
 
describe 'ORM' do
  before(:all) do
    TM.orm.instance_variable_set(:@db_adaptor, PG.connect(host: 'localhost', dbname: 'task-manager-test') )
    TM.orm.create_tables
  end
 
  before(:each) do
    TM.orm.reset_tables
  end
 
  after(:all) do
    TM.orm.drop_tables
  end
 
  it "is an ORM" do
    expect(TM.orm).to be_a(TM::ORM)
  end
 
  it "is created with a db adaptor" do
    expect(TM.orm.db_adaptor).not_to be_nil
  end
 
  describe '#add_project' do
    it "adds the project to the database and returns a Project instance" do
      expect(TM.orm.add_project("code")).to be_a(TM::Project)
    end
  end
 
  describe '#list_projects' do
    it "lists all the projects in the database as Project instances" do
      proj1 = TM.orm.add_project("code")
      proj2 = TM.orm.add_project("homework")
 
      expect(TM.orm.list_projects.map(|proj| proj.name)).to include("code", "homework")
      expect(TM.orm.list_projects[0].created_at).to eq(proj1.created_at)
    end
  end
end