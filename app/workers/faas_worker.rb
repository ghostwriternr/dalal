class FaasWorker < BaseWorker
    sidekiq_options queue: 'default'

    def perform(channel_id)
      lang="python3"
      handler="handler.py"
      
      # do something
      puts channel_id
      channel = Channel.find(channel_id)
      if channel.language == 'javascript'
        lang="node"
        handler="handler.js"
      end
      data = `cd functions && faas-cli new --lang #{lang} #{channel.uuid}`
      puts data
      
      # update handler.py
      File.delete("functions/#{channel.uuid}/#{handler}")
      file = File.open("functions/#{channel.uuid}/#{handler}", "w")
      file.puts channel.function
      file.close

      # create 
      data = `cd functions && faas-cli up -f #{channel.uuid}.yml`
      puts data
      # delete files
      FileUtils.rm_rf("functions/#{channel.uuid}")
      FileUtils.rm_rf("functions/build/#{channel.uuid}")
      File.delete("functions/#{channel.uuid}.yml")
      # sleep 30
    end
  end