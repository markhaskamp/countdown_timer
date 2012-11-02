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
  def continue_countdown? requested_duration, elapsed_seconds
    duration_units = requested_duration.split(':')
    duration_minutes = duration_units[0].to_i
    duration_seconds = duration_units[1].to_i
    requested_duration = (duration_minutes *  60) + duration_seconds
    return elapsed_seconds < requested_duration
  end

  def describe_duration requested_duration
    return "#{requested_duration}"
  end
end

class CountdownTimer
  def flatten_input_array s

    if s.instance_of? Array then
      return_args = []
      s.each do |foo|
        return_args.push foo.split
      end
      return return_args.flatten!
    end

    return s.split
  end

  def get_duration array_in
    return array_in[0] if array_in.length == 1 && array_in[0].match(':')

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
end

