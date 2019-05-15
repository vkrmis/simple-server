def enqueue_cache_warmup(record, from_time, to_time)
  record_class = record.class.to_s
  WarmUpAnalyticsCacheJob.perform_later(
    record_class,
    record.id,
    from_time,
    to_time
  )
  Rails.logger.info("Enqueued job to warm up for #{record_class} - #{record.id}")
end


def fan_out_cache_warmup(from_time, to_time)
  FacilityGroup.all.each do |facility_group|
    enqueue_cache_warmup(facility_group, from_time, to_time)
    facility_group.facilities.each do |facility|
      enqueue_cache_warmup(facility, from_time, to_time)
    end
  end
end

namespace :analytics do
  desc 'Warm up analytics for last 90 days'
  task warm_up_last_ninety_days: :environment do
    Rails.logger = Logger.new(STDOUT)

    to_time = Time.now
    from_time = to_time - 90.days

    CachedLatestBloodPressure.refresh # This refreshes the materialized view

    fan_out_cache_warmup(from_time, to_time)
  end

  task warm_up_last_four_quarters: :environment do
    Rails.logger = Logger.new(STDOUT)

    CachedLatestBloodPressure.refresh # This refreshes the materialized view

    (1..4).each do |n|
      range = ApplicationController.helpers.range_for_quarter(-1 * n)
      fan_out_cache_warmup(range.begin, range.end)
    end
  end
end