class HolidayClient

  def self.conn
    Faraday.new('https://date.nager.at')
  end

  def self.us_holidays
    response = conn.get('/api/v3/NextPublicHolidays/US')
    parse(response)
  end

  def self.parse(response)
   JSON.parse(response.body, symbolize_names: true)
  end
end
