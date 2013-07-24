require 'rubygems'
require 'github_api'
require 'chronic'
require "bundler/setup"
require "active_record"
require 'appscript'
require 'yaml'
require './models'

ActiveRecord::Base.establish_connection "sqlite3:///git_print.sqlite3"

settings = YAML.load_file(File.open('git_print.yml'))

def print_label(line_one, line_two, line_three, line_four)
  dymo = Appscript.app("DYMO Label")
  dymo.openLabel(nil, :in => "EmptyAddressLabel.label")
  dymo.addAddress(nil)
  dymo.print_objects.items[-1].content.set("#{line_one}\n#{line_two}\n#{line_three}\n#{line_four}")
  dymo.elements_[-1].xPosition.set(20)
  dymo.elements_[-1].yPosition.set(10)
  dymo.elements_[-1].height.set(60)
  dymo.elements_[-1].width.set(240)
  dymo.redrawLabel(nil)
  dymo.printLabel2(nil)
end

def print_latest(settings, first_run)
  puts "git_print is running..." unless first_run == false
  github = Github.new login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD']
  issues = github.issues.list(repo: settings["repo"], user: settings["user"], filter: settings["filter"], assignee: settings["assignee"])
  issues.body.each do |issue|
    number_milestone = "##{issue.number} #{('MS-'+ issue.milestone.title) if !issue.milestone.nil? && !issue.milestone.title.nil?}"
    begin
      db_issue = Issue.where(:number => issue.number).first
      if db_issue.updated_at.in_time_zone(-5) < issue.updated_at.in_time_zone(-5)
        print_label("TO: "+issue.assignee.login, number_milestone, issue.title, Chronic.parse(issue.updated_at).in_time_zone(-5).strftime("%m/%d/%Y at%l:%M %p")) unless first_run
        db_issue.updated_at = issue.updated_at.in_time_zone(-5)
        db_issue.save
      end
    rescue
      print_label("TO: "+issue.assignee.login, number_milestone, issue.title, Chronic.parse(issue.updated_at).in_time_zone(-5).strftime("%m/%d/%Y at%l:%M %p")) unless first_run
      Issue.create(number: issue.number, title: issue.title, body: issue.body, updated_at: Chronic.parse(issue.updated_at))
    end
  end
  puts "github fetch complete"
  sleep(10)
  print_latest(settings, false)
end

print_latest(settings, true)
