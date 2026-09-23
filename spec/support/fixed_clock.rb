# frozen_string_literal: true

class FixedClock
  def initialize(time = Time.utc(2024, 6, 1, 9, 0, 0))
    @time = time
  end

  def now
    @time
  end
end
