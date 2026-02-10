require 'asutils'

war_file_path = File.join(ASUtils.find_base_directory, 'wars/public.war')
puts "Extracting from #{war_file_path}"
jar_file = java.util.jar.JarFile.new(war_file_path)
file_to_extract = 'WEB-INF/app/views/pdf/_titlepage.html.erb'
file_to_write =  File.join(File.dirname(__FILE__), 'views/pdf/_titlepage.html.erb')
puts "Extracting to #{file_to_write}"

entries = jar_file.entries

# Find the file to extract
while entries.hasMoreElements
  entry = entries.nextElement
  if entry.name == file_to_extract
    input_stream = jar_file.get_input_stream(entry)
    buffer = Java::byte[1024].new
    content = ''

    while (len = input_stream.read(buffer)) != -1
      content += String.from_java_bytes(buffer[0, len])
    end

    input_stream.close

    # Replace logo
    content.gsub!("ArchivesSpaceLogo_for_pdf.png", "/assets/images/pui_pdf_atlas.png")

    File.open(file_to_write, 'w') do |file|
      file.write(content)
    end

    break
  end
end

jar_file.close
