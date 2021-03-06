class AnalyticsController < AdminController
  around_action :set_time_zone
  before_action :set_month, only: [:graphics]

  DEFAULT_ANALYTICS_TIME_ZONE = 'Asia/Kolkata'

  def set_time_zone
    time_zone = ENV['ANALYTICS_TIME_ZONE'] || DEFAULT_ANALYTICS_TIME_ZONE

    Groupdate.time_zone = time_zone

    Time.use_zone(time_zone) do
      yield
    end

    # Make sure we reset the timezone
    Groupdate.time_zone = "UTC"
  end

  def set_time_period
    @from_time = params.require(:from_time).to_time
    @to_time = params.require(:to_time).to_time
  end

  def set_month
    month = params.require(:month).to_time
    @from_time = month.at_beginning_of_month
    @to_time = month.at_end_of_month
  end
end
