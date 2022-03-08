# frozen_string_literal: true

module ApplicationHelper
  def embedded_svg(filename)
    file_path = "#{Rails.root}/app/assets/svg/#{filename}.svg"

    return File.read(file_path).html_safe if File.exist?(file_path)

    '(not found)'
  end
end
