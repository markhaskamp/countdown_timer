#!/Users/mark/.rvm/rubies/ruby-1.9.2-head/bin/ruby
require File.dirname(__FILE__) + '/CountdownTimer.rb'


ct = CountdownTimer.new

input_args = ct.flatten_input_array ARGV
puts "input_args: #{input_args}"
requested_duration = ct.get_duration(input_args)
duration_type = ct.get_duration_type(input_args)

time_start = Time.now()
time_end = Time.now()
elapsed_count = (time_end - time_start).to_i

while duration_type.continue_countdown?(requested_duration, elapsed_count) do
  sleep 1
  time_end = Time.now()
  elapsed_count = (time_end - time_start).to_i
end

days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dev"]
time_now = Time.now
time_msg = sprintf("%s,  %s %d,  %02d:%02d", 
                    days[time_now.wday],
                    months[time_now.mon-1], 
                    time_now.mday, 
                    time_now.hour, 
                    time_now.min)
message = "#{duration_type.describe_duration(requested_duration)}"
`~/bin/terminal-notifier/terminal-notifier_1.4.2/terminal-notifier.app/Contents/MacOS/terminal-notifier -message "#{message}\n#{time_msg}" -title "Time's up"`

