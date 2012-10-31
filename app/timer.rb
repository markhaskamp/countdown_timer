#!/Users/mark/.rvm/rubies/ruby-1.9.2-head/bin/ruby

# get duration, duration-type from command line
#   e.g. 5 minutes, or 30 seconds, or 1 hour

duration = ARGV[0].to_i
type = ARGV[1]

time_start = Time.now()
time_end = Time.now()
elapsed_count = (time_end - time_start).to_i

while elapsed_count < duration do
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
message = "#{duration} seconds"
`~/bin/terminal-notifier/terminal-notifier_1.4.2/terminal-notifier.app/Contents/MacOS/terminal-notifier -message "#{message}\n#{time_msg}" -title "Time's up"`

