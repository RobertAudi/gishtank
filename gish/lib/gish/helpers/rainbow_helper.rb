module Gish::Helpers::RainbowHelper
  # Black       0;30     Dark Gray     1;30
  # Blue        0;34     Light Blue    1;34
  # Green       0;32     Light Green   1;32
  # Cyan        0;36     Light Cyan    1;36
  # Red         0;31     Light Red     1;31
  # Purple      0;35     Light Purple  1;35
  # Brown       0;33     Yellow        1;33
  # Light Gray  0;37     White         1;37

  COLOR_CODES = {
    white:         "0",
    black:         "0;30",
    blue:          "0;34",
    green:         "0;32",
    cyan:          "0;36",
    red:           "0;31",
    purple:        "0;35",
    yellow:        "0;33",
    gray:          "0;37",
    bold_blue:     "1;34",
    bold_green:    "1;32",
    bold_cyan:     "1;36",
    bold_red:      "1;31",
    bold_purple:   "1;35",
    bold_yellow:   "1;33",
    bold_gray:     "1;30",
    bold_white:    "1;37"
  }

  COLOR_CODE_PREFIX = "\033["
  COLOR_CODE_SUFFIX = "m"

  def paint(message: "", color: "white")
    raise Gish::Exceptions::InvalidColorError.new color: color unless COLOR_CODES.has_key?(color.to_sym)

    COLOR_CODE_PREFIX + COLOR_CODES[color.to_sym] + COLOR_CODE_SUFFIX + message + COLOR_CODE_PREFIX + COLOR_CODES[:white] + COLOR_CODE_SUFFIX
  end

  COLOR_CODES.keys.each do |color|
    unless color.to_s =~ /bold_/
      define_method color do |message: "", bold: false|
        paint_color = bold ? "bold_#{color}" : "#{color}"
        paint message: message, color: paint_color
      end
    end
  end
end
