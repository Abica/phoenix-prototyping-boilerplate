#!/usr/bin/env ruby -w

args = ARGV

IS_DRY_RUN = !!args.delete('--dry-run')
PROJECT_NAME = args.first

if PROJECT_NAME.nil?
  puts "usage: ruby #{$0} project_name [ModuleBaseName] [--dry-run]"
  exit
end

def camelize(v)
  v.split("_").map(&:capitalize).join
end

TEMPLATE_DIR = "template"
TEMPLATE_KEY_NAME = "xxxx_xxxx"
TEMPLATE_MODULE_NAME = camelize(TEMPLATE_KEY_NAME)

BUILD_DIR = "build"
PROJECT_DIR = File.join(BUILD_DIR, PROJECT_NAME)
BACKUP_EXT_NAME = ".bak"

MODULE_NAME = args[1] || camelize(PROJECT_NAME)

def pipe(*commands)
  commands.join(" | ")
end

def grep(term, dir)
  %{grep -R "#{term}" #{dir}}
end

def ignore(term)
  %{grep -v "#{term}"}
end

def cut(delim = ":", field = 1)
  %{cut -d #{delim} -f #{field}}
end

def sed(from, to)
   %{xargs sed -i#{BACKUP_EXT_NAME} 's/#{from}/#{to}/g'}
end

def replace_recursively(from, to)
  pipe(
    grep(from, PROJECT_DIR),
    cut,
    ignore("Binary"),
    sed(from, to)
  )
end

def mv(from, to)
  %{mv "#{from}" "#{to}"}
end

def cleanup(ext = BACKUP_EXT_NAME)
  %{find #{PROJECT_DIR} -name "*#{ext}" -exec rm {} \\;}
end

def rename_files(from, to)
  paths = Dir["#{TEMPLATE_DIR}/*/*#{from}*"]
  paths.map do |path|
    new_path = path.gsub(TEMPLATE_DIR, PROJECT_DIR)
    mv(new_path, new_path.gsub(from, to))
  end
end

commands = [
  # create build dir
  %{mkdir -p #{BUILD_DIR}},

  # clone template into new project directory
  %{cp -R #{TEMPLATE_DIR} #{PROJECT_DIR}},

  # change filenames
  rename_files(TEMPLATE_KEY_NAME, PROJECT_NAME),

  # change key names
  replace_recursively(TEMPLATE_KEY_NAME, PROJECT_NAME),

  # change module names
  replace_recursively(TEMPLATE_MODULE_NAME, MODULE_NAME),

  # delete temp backup files
  cleanup(BACKUP_EXT_NAME)
].flatten

puts "Starting dry run..." if IS_DRY_RUN
commands.each do |command|
  puts command
  system(command) unless IS_DRY_RUN
end

unless IS_DRY_RUN
  puts "\n! Finished creating project in #{PROJECT_DIR}. Start it up:"
  puts
  puts "\tcd #{PROJECT_DIR}"
  puts "\tmix do deps.get, ecto.setup, ecto.migrate"
  puts "\tmix phx.server"
  puts
  puts "Seeing an error with the UUID lib? Re-running the failing command should fix the problem."
end
