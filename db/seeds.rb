Template.destroy_all
Dir.foreach('functions/template') do |folderName|
  next if (folderName == '.') || (folderName == '..')

  functionTemplateFolder = "functions/template/#{folderName}/function"
  case folderName
  when 'python3'
    templateContent = File.read("#{functionTemplateFolder}/handler.py")
    Template.create(content: templateContent, language: 'python')
  when 'node'
    templateContent = File.read("#{functionTemplateFolder}/handler.js")
    Template.create(content: templateContent, language: 'javascript')
  end
end
