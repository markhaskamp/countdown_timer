#!/Users/mark/.rvm/rubies/ruby-1.9.2-head/bin/ruby
require File.dirname(__FILE__) + '/CountdownTimer.rb'
require 'optparse'

def help_message

  return <<EOH
Usage:

  countdown_timer -h      display this screen
  countdown_timer --help   "   "    "    "

  countdown_timer mm:ss
  or countdown_timer [amount] m[inutes]
  or countdown_timer [amount] s[econds]

Examples:
  countdown_timer 5:00
  countdown_timer 3 minutes
  countdown_timer 3 m
  countdown_timer 30 seconds
  countdown_timer 30 s
EOH
end

options = {}
option_parser = OptionParser.new do |opts|
  opts.on("-h", "--help") do
    puts help_message
    exit(0)
  end
end
option_parser.parse!


if ARGV.length == 0 then
  puts help_message
  exit(0)
end

ct = CountdownTimer.new

days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dev"]
time_now = Time.now
time_msg = sprintf("%s,  %s %d,  %02d:%02d", 
                    days[time_now.wday],
                    months[time_now.mon-1], 
                    time_now.mday, 
                    time_now.hour, 
                    time_now.min)

input_args = ct.flatten_input_array ARGV
requested_duration = ct.get_duration(input_args)
duration_type = ct.get_duration_type(input_args)

message = "#{duration_type.describe_duration(requested_duration)}"
`~/bin/terminal-notifier/terminal-notifier_1.4.2/terminal-notifier.app/Contents/MacOS/terminal-notifier -message "#{message}\n#{time_msg}" -title "Start"`

time_start = Time.now()
time_end = Time.now()
elapsed_count = (time_end - time_start).to_i

while duration_type.continue_countdown?(requested_duration, elapsed_count) do
  sleep 1
  time_end = Time.now()
  elapsed_count = (time_end - time_start).to_i
end

time_now = Time.now
time_msg = sprintf("%s,  %s %d,  %02d:%02d", 
                    days[time_now.wday],
                    months[time_now.mon-1], 
                    time_now.mday, 
                    time_now.hour, 
                    time_now.min)


message = "#{duration_type.describe_duration(requested_duration)}"
message = "#{duration_type.describe_duration(ARGV)}" if duration_type.instance_of? Unknown
`~/bin/terminal-notifier/terminal-notifier_1.4.2/terminal-notifier.app/Contents/MacOS/terminal-notifier -message "#{message}\n#{time_msg}" -title "Time's up"`

