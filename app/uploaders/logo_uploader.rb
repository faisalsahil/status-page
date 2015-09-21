# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base
  
  
  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick

   process :store_dimensions
   # include CarrierWave::MiniMagick
   # include CarrierWave::MiniMagick
   require 'carrierwave/test/matchers'

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  @uploader = LogoUploader.new(@user, :avatar)

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def store_dimensions
    if file && model
      img = ::Magick::Image::read(file.file).first
      raise ActiveRecord::Base::Exception, "Dimensions are not valid" if (img.columns.to_i > 100) || (img.rows.to_i > 200)
    end
  end
  
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end


  # def image
  #   @image ||= MiniMagick::Image.open( model.send(mounted_as).path )
  # end

  # def image_width 
  #    image[:width]
  # end


  # def image_height
  #   image[:height]
  # end


  # def image_width 
  #   image[:width]
  # end

  # def image_height
  #   image[:height]

  # end

  # def image_height
  #   image[:height]
  # end


  # def self.scale_image
  #   width = image_width #function defined above
  #   height = image_height #function defined above
  #   if width && height && width > 100 && height > 200
  #    puts "========="*80

  # def scale_image
  #   width = image_width #function defined above
  #   height = image_height #function defined above
  #   if width && height && width > 100 && height > 200
  #   puts "========="*80

  #   end

  # end

  # end

  


  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  def scale(width, height)
    process :scale => [100, 200]
  end
  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_limit => [100, 200]
  end
    

  

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
