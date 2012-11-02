#!/Users/mark/.rvm/rubies/ruby-1.9.2-head/bin/ruby

class Seconds
  def continue_countdown? requested_duration, elapsed_seconds
    return elapsed_seconds < requested_duration
  end

  def describe_duration requested_duration
    return "#{requested_duration} second" if requested_duration == 1

    return "#{requested_duration} seconds"
  end
end

class Minutes
  def continue_countdown? requested_duration, elapsed_seconds
    return (requested_duration*60) > elapsed_seconds
  end
  def describe_duration requested_duration
    return "#{requested_duration} minute" if requested_duration == 1

    return "#{requested_duration} minutes"
  end
end

class Composite
  # def continue_countdown? requested_duration, elapsed_seconds
  #   return elapsed_seconds < requested_duration
  # end

  # def describe_duration requested_duration
  #   return "#{requested_duration} second" if requested_duration == 1

  #   return "#{requested_duration} seconds"
  # end
end
class CountdownTimer
  def get_duration array_in
    array_in.each do |arg|
      if arg.to_i > 0
        return arg.to_i
      end
    end

    return 0
  end

  def get_duration_type array_in
    array_in.each do |arg|
      return Seconds.new if arg.to_s.match('^[sS]')
      return Minutes.new if arg.to_s.match('^[mM]')
      return Composite.new if arg.to_s.match('\d+:\d+')
    end

    return Minutes.new
  end

  def main
    requested_duration = get_duration(ARGV)
    duration_type = get_duration_type(ARGV)
    
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
  end
end

CountdownTimer.new.main
