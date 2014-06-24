require 'pg'
require 'pry-byebug'
require 'time'

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
      project = TM::Project.new(result[0][0].to_i, result[0][1])
      # binding.pry
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

    def create_task(proj_id, priority, desc)
      creation_date = Time.now
      command = <<-SQL
        INSERT INTO tasks(description, project_id, priority, status_done, creation_date)
        VALUES('#{desc}', #{proj_id}, '#{priority}' , false, '#{creation_date}')
        RETURNING *;
      SQL
      # binding.pry
      result = @db_adapter.exec(command).values
      # binding.pry
      task = TM::Task.new(result[0][0].to_i, result[0][1], result[0][2].to_i, result[0][3], result[0][4], 'f', creation_date, nil)
      return task
    end

    def complete_task(tid)
      completion_date = Time.now
      command = <<-SQL
        UPDATE tasks
        SET status_done = true, completion_date = '#{completion_date}'
        WHERE tasks.task_id = #{tid}
        RETURNING *;
      SQL

      result = @db_adapter.exec(command).values
      task = TM::Task.new(result[0][0].to_i, result[0][1], result[0][2].to_i, result[0][3], result[0][4].to_i, result[0][5], Time.parse(result[0][6]), Time.parse(result[0][7]))
      # binding.pry
      return task
    end

    def remaining_tasks(pid)
      command = <<-SQL
        SElECT * FROM tasks
        where project_id = #{pid} AND status_done = 'f';
      SQL

      result = @db_adapter.exec(command).values
      tasks_left = []
      result.each { |task_data|
        task = TM::Task.new(task_data[0].to_i, task_data[1], pid, task_data[3], task_data[4].to_i, task_data[5], Time.parse(task_data[6]), task_data[7])
        tasks_left << task
      }
      return tasks_left
    end

    def finished_tasks(pid)
      command = <<-SQL
        SElECT * FROM tasks
        where project_id = #{pid} AND status_done = 't';
      SQL

      result = @db_adapter.exec(command)
      finished_tasks = []
      result.values.each { |task_data|
        task = TM::Task.new(task_data[0].to_i, task_data[1], pid, task_data[3], task_data[4].to_i, task_data[5], Time.parse(task_data[6]), Time.parse(task_data[7]))
        finished_tasks << task
      }
      return finished_tasks

    end

    def create_user(name)
      command = <<-SQL
        INSERT INTO users(name)
        VALUES('#{name}')
        RETURNING *;
      SQL

      result = @db_adapter.exec(command).values
      id = result[0][0].to_i
      name = result[0][1]
      user = TM::User.new(id, name)
      return user
    end

    def assign_to_proj(uid, pid)
      command = <<-SQL
        INSERT INTO projects_users(user_id, project_id)
        VALUES(#{uid}, #{pid})
        RETURNING *;
      SQL

      result = @db_adapter.exec(command).values
      return result[0]
    end

    def remove_user_from_proj(uid, pid) #need to also unassign all tasks this user had
      command = <<-SQL
        DELETE FROM projects_users
        WHERE project_id = #{pid} AND user_id = #{uid};
        UPDATE tasks
        SET user_assigned = NULL
        WHERE tasks.user_assigned = #{uid} AND tasks.project_id = #{pid};
      SQL

      @db_adapter.exec(command)
    end

    def assign_task(uid, tid)
      task = task_lookup(tid)
      command = <<-SQL
        SELECT *
        FROM projects p
        JOIN projects_users pu
        ON p.project_id = pu.project_id
        JOIN users u
        ON u.user_id = pu.user_id
        WHERE u.user_id = #{uid} AND p.project_id = #{task.proj_id};
      SQL

      result = @db_adapter.exec(command).values

      if result.length == 1 && task.done == 'f'
        command = <<-SQL
          UPDATE tasks
          SET user_assigned = #{uid}
          WHERE tasks.task_id = #{tid};
        SQL

        @db_adapter.exec(command)
        # binding.pry
        return task_lookup(tid)
      else 
        return "Sorry, not a valid task assignment"
      end
    end

    def task_lookup(tid)
      command = <<-SQL
        SElECT * FROM tasks
        where task_id = #{tid}
      SQL

      result = @db_adapter.exec(command).values
      result[0][7].nil? ? completion_date = nil : completion_date = Time.parse(result[0][7])
      task = TM::Task.new(result[0][0].to_i, result[0][1], result[0][2].to_i, result[0][3], result[0][4].to_i, result[0][5], Time.parse(result[0][6]), completion_date)
      # binding.pry
      return task
    end

    def delete_proj(pid) #Extra credit
    end

    def delete_user(uid) #Extra credit
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