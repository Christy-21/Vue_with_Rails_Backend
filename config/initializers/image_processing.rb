# config/initializers/image_processing.rb
require "image_processing/mini_magick"

ImageProcessing::MiniMagick.configure do |config|
  config.define_mini_magick_commands(
    mogrify:  ["-resize", "250x250>"],
    convert:  ["-resize", "250x250>"],
    identify: ["-format", "%wx%h"]
  )
end
