require 'asutils'
require 'fileutils'
require 'tempfile'

class PluginsZip
  def initialize
    @plugins = AppConfig[:plugins]
  end

  def write(name)
    raise StandardError.new "Plugin name not valid" if !@plugins.include?(name)

    @base_dir = File.join(plugin_base_directory, name)
    entries = Dir.children(@base_dir)
    create_zip_file(entries)
  end

  def write_all
    @base_dir = plugin_base_directory
    entries = Dir.children(@base_dir).reject { |p| !@plugins.include?(p) }
    create_zip_file(entries)
  end

  def self.clean_tempfiles
    expired_files = Dir.glob(File.join(Dir.tmpdir, 'atlas_hosting*')).reject { |f| File.mtime(f) > (Time.now - 300) }
    return if expired_files.empty?

    Rails.logger.info("Atlas Hosting") { "Cleaning up #{expired_files.length} temporary files" }
    FileUtils.rm expired_files, :force => true
  end

private

  def plugin_base_directory
    if ASUtils.respond_to?(:plugin_base_directory)
      ASUtils.plugin_base_directory
    else
      # Older versions of ArchivesSpace prior to v3.1 don't have ASUtils.plugin_base_directory
      # The following code is from v3.4.1
      # https://github.com/archivesspace/archivesspace/blob/4b3bde0ccc63db4d182a46c5960f5c9921888581/common/asutils.rb#L100-L111

      # if a specific plugins directory is set in config.rb,
      # we use that. Otherwise, find the 'plugins' dir in the
      # aspace base.
      if AppConfig.changed?(:plugins_directory)
        # Yields something relative to our base directory if a relative path is used.
        # Absolute paths will pass through unchanged.
        File.absolute_path(AppConfig[:plugins_directory], ASUtils.find_base_directory)
      else
        File.join( *[ ASUtils.find_base_directory, 'plugins'])
      end
    end
  end

  def create_zip_file(entries)
    @output_file = Tempfile.new('atlas_hosting-')
    @output_file.close

    Rails.logger.info("Atlas Hosting") { "Creating zip file #{@output_file.path}" }

    zipfile = java.util.zip.ZipOutputStream.new(java.io.FileOutputStream.new(@output_file.path))
    begin
      compress_entries(zipfile, entries, '')
    ensure
      zipfile.close
    end

    @output_file
  end

  def compress_entries(zipfile, entries, path)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_path = File.join(@base_dir, zipfile_path)

      if File.directory? disk_path
        compress_directory(zipfile, disk_path, zipfile_path)
      else
        compress_file(zipfile, zipfile_path, disk_path)
      end
    end
  end

  def compress_directory(zipfile, disk_path, zipfile_path)
    zipfile.put_next_entry(java.util.zip.ZipEntry.new(zipfile_path + '/'))
    entries = Dir.children(disk_path)
    compress_entries(zipfile, entries, zipfile_path)
  end

  def compress_file(zipfile, zipfile_path, disk_path)
    entry = zipfile.put_next_entry(java.util.zip.ZipEntry.new(zipfile_path))

    unless File.directory?(disk_path)
      handle = java.io.FileInputStream.new(disk_path)

      begin
        buffer = Java::byte[4096].new
        while (len = handle.read(buffer)) >= 0
          zipfile.write(buffer, 0, len)
        end
      ensure
        handle.close
      end
    end
  end
end
