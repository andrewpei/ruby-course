require_relative 'lib/task-manager.rb'

class TerminalClient

  def initialize
    @projects_list = {}
  end

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
      when "add"
        pid = parameters[0].to_i
        priority = parameters[1].to_s
        description = parameters.slice(2, parameters.length).join(" ")
        self.add(pid, priority, description)
      when "mark"
        self.mark(parameters[0].to_i, parameters[1].to_i)
      when "quit"
        puts "See you next time!"
        keep_going = false
      else
        puts "Invalid command. Try again"
        next
      end

    end
  end

  def help
    puts "Available commands:"
    puts "  help - Show these commands again"
    puts "  list - list all projects"
    puts "  create NAME - Create a new project with name=NAME"
    puts "  show PID - Show remaining tasks for project with id=PID"
    puts "  history PID - Show completed tasks for project with id=PID"
    puts "  add PID PRIORITY DESC - Add a new task to project with id=PID"
    puts "  mark PID TID - Mark task id=TID in project=PID as complete"
    puts "  quit - Quits this program."
    return
  end

  def user_input(string)
    input_array = string.split(" ")
    return input_array
  end

  def list
    puts "Showing all projects:"
    puts "(Name)  (Project ID)  (Tasks Left)"
    @projects_list.each { |id, project|
      puts "#{project.name}  #{id}  (#{project.tasks_left.size})"
    }
    puts "\n"
  end

  def create(name)
    temp = TM::Project.new(name)
    @projects_list[temp.project_id] = temp
    puts "New project created with ID: #{temp.project_id} and NAME: #{temp.name}"
    return temp.project_id
  end

  def show(pid)
    project = @projects_list[pid]
    puts "Showing tasks for project: #{project.name}, PID: #{project.project_id}\n"
    puts "(Priority) (Task ID) (Description) (Creation Date)"
    project.remaining_tasks.each { |task|
      puts "#{task.priority}  #{task.task_id}  #{task.description}  #{task.creation_date}"
    }
    puts "\n"
  end

  def history(pid)
    project = @projects_list[pid]
    puts "Showing completed tasks for project: #{project.name}, PID: #{project.project_id}\n"
    puts "(Priority)  (Task ID)  (Description)  (Completion Date)"
    project.finished_tasks.each { |task|
      puts "#{task.priority}  #{task.task_id}  #{task.description}  #{task.completion_date}"
    }
    puts "\n"
  end

  def add(pid, priority, description)
    project = @projects_list[pid]
    project.create_task(priority, description)
    puts "Task added successfully to #{project.name}"
  end

  def mark(pid, tid) #Not working at the moment
    project = @projects_list[pid]
    project.complete_task(tid)
    puts "Task ID: #{tid} in project: #{project.name} has been marked complete"
  end

end

# t = TerminalClient.new
# pid = t.create("blah")
# t.add(pid,"major", "hello world")
# t.add(pid,"blocker", "yes man")
# t.add(pid,"blocker", "no man")
# t.add(pid,"critical", "blahblah")
# t.list
# t.show(pid)
# t.start
# t.mark(pid,1)
# t.mark(pid,3)
# t.history(pid)

