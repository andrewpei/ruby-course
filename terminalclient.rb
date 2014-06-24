require_relative 'lib/task-manager.rb'

class TerminalClient

  def start
    puts "Welcome to Andrew's Project Manager"
    puts "\n"
    self.help
    keep_going = true
    
    while keep_going
      puts ""
      print "Input command >> "
      userInput = user_input(gets.chomp)
      command = userInput[0].downcase
      parameters = userInput.slice(1,userInput.length)

      case command
      when "help"
        self.help
      when "list"
        self.list
      when "create"
        self.create(parameters.join(" "))
      when "show"
        self.show(parameters[0].to_i)
      when "history"
        self.history(parameters[0].to_i)
      when "createuser"
        self.create_user(parameters)
      when "assigntoproj"
        self.assign_proj(parameters[0].to_i, parameters[1].to_i)
      when "removefromproj"
        self.remove_from_proj(parameters[0].to_i, parameters[1].to_i)
      when "assigntask"
        self.assign_task(parameters[0].to_i, parameters[1].to_i)
      when "add"
        pid = parameters[0].to_i
        priority = parameters[1].to_s
        description = parameters.slice(2, parameters.length).join(" ")
        self.add(pid, priority, description)
      when "mark"
        self.mark(parameters[0].to_i)
      else
        puts "Invalid command. Try again"
        next
      end

    end
  end

  def help
    puts "Available commands:"
    puts "  help - Show these commands again"
    puts "  create NAME - Create a new project with name=NAME"
    puts "  list - list all projects"
    puts "  createuser NAME - Create a new user with name=NAME"
    puts "  assignuserproj UID PID - Assigns user with user ID=UID to project ID=PID"
    puts "  removeuserproj UID PID - Removes user with user ID=UID from project ID=PID"
    puts "  assigntask UID TID - Assigns task with ID=TID to user with user ID=UID"
    puts "  show PID - Show remaining tasks for project with id=PID"
    puts "  history PID - Show completed tasks for project with id=PID"
    puts "  add PID PRIORITY DESC - Add a new task to project with id=PID"
    puts "  mark TID - Mark task id=TID as complete"
    puts ""
    return
  end

  def user_input(string)
    input_array = string.split(" ")
    return input_array
  end

  def create(name)
    temp = TM.orm.add_project(name)
    puts "New project created with ID: #{temp.project_id} and NAME: #{temp.name}"
    return temp.project_id
  end

  def list
    puts "Showing all projects:"
    puts "(Name)  (Project ID)"
    TM.orm.list_projects.each { |project|
      puts "#{project.name}  #{project.project_id}"
    }
    puts "\n"
  end

  def show(pid)
    priority_hash = {
      "minor" => 1,
      "normal" => 2,
      "major" => 3,
      "critical" => 4,
      "blocker" => 5
    }

    puts "Showing tasks for PID: #{pid}\n"
    puts "(Priority)  (Task ID)  (Description)  (Creation Date)  (User Assigned)"

    sortedTasks = TM.orm.remaining_tasks(pid).sort { |task1, task2|
      if priority_hash[task1.priority] == priority_hash[task2.priority]
        (task1.creation_date > task2.creation_date) ? 1 : -1
      elsif priority_hash[task1.priority] < priority_hash[task2.priority]
        1
      elsif priority_hash[task1.priority] > priority_hash[task2.priority]
        -1
      end
    }

    sortedTasks.each { |task|
      puts "#{task.priority}  #{task.task_id}  #{task.description}  #{task.creation_date}  #{task.user_assigned}"
    }
    puts "\n"
  end

  def history(pid)
    puts "Showing completed tasks for PID: #{pid}\n"
    puts "(Priority)  (Task ID)  (Description)  (Completion Date)  (User Assigned)"

    sortedTasks = TM.orm.finished_tasks(pid).sort { |task1, task2|
      (task1.completion_date > task2.completion_date) ? -1 : 1
    }

    sortedTasks.each { |task|
      puts "#{task.priority}  #{task.task_id}  #{task.description}  #{task.completion_date}  #{task.user_assigned}"
    }
    puts "\n"
  end

  def add(pid, priority, description)
    task = TM.orm.create_task(pid, priority, description)
    puts "Task added successfully to PID: #{task.proj_id}"
    return task
  end

  def mark(tid)
    task = TM.orm.complete_task(tid)
    puts "Task ID: #{tid} in project ID: #{task.proj_id} has been marked complete"
  end

  def create_user(name)
    user = TM.orm.create_user(name)
    puts "New user created with ID: #{user.user_id} and NAME: #{user.name}"
    return user
  end

  def assign_to_proj(uid, pid)
    TM.orm.assign_to_proj(uid, pid)
    puts "User with ID: #{uid} has been assigned to project ID: #{pid}"
  end

  def remove_from_proj(uid, pid) 
    TM.orm.remove_user_from_proj(uid, pid)
    puts "User with ID: #{uid} has been removed from project ID: #{pid}"
  end

  def assign_task(uid, tid)
    result = TM.orm.assign_task(uid, tid)
    if result.instance_of?(String)
      puts result
    else
      return result
    end
  end

end

TM.orm.delete_tables
TM.orm.create_tables
t = TerminalClient.new

pid = t.create("blah")
pid2 = t.create("project two")

t.add(pid,"major", "hello world")
task = t.add(pid,"blocker", "yes man")
t.add(pid2,"blocker", "no man")
t.add(pid2,"critical", "blahblah")

andrew = t.create_user("Andrew")
bob = t.create_user("Bob")
t.assign_to_proj(andrew.user_id, pid)
t.assign_to_proj(bob.user_id, pid)
t.assign_to_proj(bob.user_id, pid2)
t.remove_from_proj(bob.user_id, pid)
t.assign_task(andrew.user_id, task.task_id)

t.list
t.show(pid)

t.mark(1)
t.mark(3)
t.history(pid)