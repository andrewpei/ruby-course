require 'pg'
require 'pry-byebug'

module TM
  class DB
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'task-manager')
    end

    def list_projects
      command = <<-SQL
        SELECT * FROM projects;
      SQL

      #[["code", "1"], ["fun time", "2"]]
      result = @db.exec(command).values

      projects = []
      result.each do |project|
        projects << TM::Project.new(project[0], project[1])
      end
      projects
    end

    def add_project(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES('#{name}');
      SQL

      @db.exec(command)
    end

    def drop_tables
      command = <<-SQL
        DROP TABLE tasks;
        DROP TABLE projects;
      SQL

      @db.exec(command)
    end

    def create_tables
      command = <<-SQL
        CREATE TABLE projects(
          name TEXT,
          id SERIAL PRIMARY KEY
        );
        CREATE TABLE tasks(
          description TEXT,
          priority_number INTEGER,
          project_id INTEGER REFERENCES projects(id),
          id SERIAL PRIMARY KEY
        );
      SQL

      @db.exec(command)
    end
  end

  def self.db
    @__db_instance ||= DB.new
  end
end

