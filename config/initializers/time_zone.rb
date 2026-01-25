zone_name = ENV["TZ"] || begin
  # https://github.com/rails/rails/blob/v6.0.2.1/railties/lib/rails/tasks/misc.rake#L46-L48
  jan_offset = Time.now.beginning_of_year.utc_offset
  jul_offset = Time.now.beginning_of_year.change(month: 7).utc_offset
  offset = jan_offset < jul_offset ? jan_offset : jul_offset
  ActiveSupport::TimeZone.all.detect {|zone| zone.utc_offset == offset }.tzinfo.name
end
Time.zone_default = Time.find_zone!(zone_name)
ActiveRecord::Base.time_zone_aware_attributes = true
