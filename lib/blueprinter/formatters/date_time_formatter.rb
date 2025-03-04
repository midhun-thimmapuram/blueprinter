# frozen_string_literal: true

module Blueprinter
  class DateTimeFormatter
    InvalidDateTimeFormatterError = Class.new(BlueprinterError)

    def format(value, options)
      return value if value.nil?

      field_format = options[:datetime_format] || Blueprinter.configuration.datetime_format
      return value if field_format.nil?

      return format_datetime(value, field_format) if value.respond_to?(:strftime)

      raise InvalidDateTimeFormatterError, 'Cannot format invalid DateTime object' if options[:datetime_format]

      value
    end

    private

    def format_datetime(value, field_format)
      case field_format
      when Proc then field_format.call(value)
      when String then value.strftime(field_format)
      else
        raise InvalidDateTimeFormatterError, "Cannot format DateTime object with invalid formatter: #{field_format.class}"
      end
    end
  end
end
