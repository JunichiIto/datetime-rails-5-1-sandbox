require 'test_helper'

class DatetimeTest < ActiveSupport::TestCase
  setup do
    ENV['TZ'] = 'Asia/Tokyo'

    # 参考: timezone.rbの設定
    # Time.zone = 'Eastern Time (US & Canada)'

    time_for_freeze = Time.local(2015, 1, 1)
    Timecop.freeze time_for_freeze
  end

  teardown do
    Timecop.return
  end

  def l(object)
    format = ->(date_or_time) { [I18n.l(date_or_time), date_or_time.try(:zone), date_or_time.class].compact.join(', ') }
    if object.is_a?(Range)
      str = [object.first, object.last].map{|date_or_time| format.call(date_or_time)}.join('..')
    else
      str = format.call(object)
    end
    str
  end

  test 'timezone' do
    assert_equal 'Asia/Tokyo', ENV['TZ']
    assert_equal 'Eastern Time (US & Canada)', Time.zone.name
  end

  test 'time' do
    assert_equal '2015/01/01 00:00:00, JST, Time', l(Time.now)
    assert_equal '2014/12/31 10:00:00, EST, ActiveSupport::TimeWithZone', l(Time.current)
  end

  test 'date' do
    assert_equal '2015/01/01, Date', l(Date.today)
    assert_equal '2014/12/31, Date', l(Date.current)
    assert_equal '2015/01/01 00:00:00, JST, Time', l(Date.today.to_time)
    assert_equal '2015/01/01 00:00:00, EST, ActiveSupport::TimeWithZone', l(Date.today.in_time_zone)
  end
end
