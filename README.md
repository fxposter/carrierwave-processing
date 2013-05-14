# CarrierWave::Processing

Additional processing support for MiniMagick and RMagick. These are processors that I've been using in multiple projects so I decided to extract those as a gem.

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-processing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-processing

## Usage

This gem add several useful methods to CarrierWave processing RMagick and MiniMagick modules: `quality` and `strip`.
To use those, you should include specified module (RMagick or MiniMagick) into your uploader and use processors:

    class AvatarUploader < CarrierWave::Uploader::Base
      include CarrierWave::RMagick
      include CarrierWave::Processing::RMagick

      process :strip # strip image of all profiles and comments
      process :resize_to_fill => [200, 200]
      process :quality => 90 # Set JPEG/MIFF/PNG compression level (0-100)
      process :convert => 'png'
      process :colorspace => :rgb # Set colorspace to rgb or cmyk

      def filename
        super.chomp(File.extname(super)) + '.png'
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
