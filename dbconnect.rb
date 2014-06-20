require 'pg'
require 'pry-byebug'

module TM
  class ORM
    attr_reader :db_adapter

    def initialize
      @db_adapter = PG.connect(host: 'localhost', dbname: 'tm-db')
    end

    def add_project(proj_name)
      command = <<-SQL
        INSERT INTO projects(name)
        VALUES('#{proj_name}')
        RETURNING *;
      SQL

      result = @db_adapter.exec(command).values
      project = TM::Project.new(result[0][0], result[0][1])
      return project
    end

    def list_projects
      command = <<-SQL
        SElECT * FROM projects
      SQL

      result = @db_adapter.exec(command).values
      projects = []
      result.each { |proj|
        projects << TM::Project.new(proj[0],proj[1])
      }
      return projects
    end

    def create_task(desc, proj_id, priority)
      creation_date = Time.now
      command = <<-SQL
        INSERT INTO tasks(description, project_id, priority, status_done, creation_date)
        VALUES('#{desc}', #{proj_id}, '#{priority}' , false, '#{creation_date}')
        RETURNING *;
      SQL

      result = @db_adapter.exec(command).values
      # binding.pry
      task = TM::Task.new(result[0][0].to_i, result[0][1], result[0][2].to_i, result[0][3], 'f', creation_date)
      # binding.pry
      return task
    end

    def complete_task(tid)
      command = <<-SQL
        UPDATE tasks
        SET status_done = true
        WHERE tasks.task_id = '#{tid}';
      SQL

      @db_adapter.exec(command)
    end

    def remaining_tasks(pid)
      command = <<-SQL
        SElECT * FROM tasks
        where project_id = '#{pid}' AND status_done = 'f';
      SQL

      result = @db_adapter.exec(command)
      tasks_left = []
      result.values.each { |task_data|
        task = TM::Task.new(pid, task_data[1], task_data[0], task_data[6], task_data[3])
        tasks_left << task
      }
      return tasks_left
    end

    def finished_tasks(pid)
      command = <<-SQL
        SElECT * FROM tasks
        where project_id = '#{pid}' AND status_done = 't';
      SQL

      result = @db_adapter.exec(command)
      finished_tasks = []
      result.values.each { |task_data|
        task = TM::Task.new(pid, task_data[1], task_data[0], task_data[6], task_data[3])
        task.status = :complete
        task.completion_date = task_data[7]
        finished_tasks << task
      }
      return finished_tasks

    end

    def create_user(name)

    end

    def assign_to_proj()
    
    end

    def remove_from_proj()
    end

    def assign_task()
    end

    def delete_proj(pid)

    end

    def delete_tables
      command = <<-SQL
        DROP TABLE tasks;
        DROP TABLE projects_users;
        DROP TABLE projects;
        DROP TABLE users;
      SQL

      @db_adapter.exec(command)
    end

    def create_tables
      command = <<-SQL
        CREATE TABLE projects(
          project_id SERIAL PRIMARY KEY,
          name text
        );

        CREATE TABLE users(
          user_id SERIAL PRIMARY KEY,
          name text
        );

        CREATE TABLE tasks(
          task_id SERIAL PRIMARY KEY,
          description text,
          project_id INTEGER REFERENCES projects (project_id),
          priority text,
          user_assigned INTEGER REFERENCES users (user_id),
          status_done boolean,
          creation_date timestamptz,
          completion_date timestamptz
        );

        CREATE TABLE projects_users(
          id SERIAL PRIMARY KEY,
          project_id integer REFERENCES projects(project_id),
          user_id integer REFERENCES users(user_id)
        );
      SQL

      @db_adapter.exec(command)
    end

  end

  def self.orm
    @__db_adapter_instance ||= ORM.new
  end

end