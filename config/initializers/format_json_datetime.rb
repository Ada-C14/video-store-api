class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime('%a, %d %b %Y %H:%M:%S %Z')
  end
end

