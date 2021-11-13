class HolidayService

  def self.upcoming_holidays(quantity = 3)
    holidays = HolidayClient.us_holidays
    holidays[0..(quantity - 1)].map do |data|
      Holiday.new(data)
    end
  end
end
