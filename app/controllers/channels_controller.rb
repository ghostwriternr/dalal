class ChannelsController < ApplicationController
    def show
        init_channel(params['id'])
        render json: @channel || {} 
    end

    def create
        @channel = Channel.new(uuid: SecureRandom.hex(10))
        if @channel.save
            render json: @channel, status: :created
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    def update
        init_channel(params['id'])
        if !@channel.nil? && @channel.update(channel_params)
            FaasWorker.perform_async(@channel.id)
            render json: @channel
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    def generate_function
        init_channel(params['id'])
        if !@channel.nil?
            create_openfaas_function(@channel)
            render json: { ok: true }
        end
    end

    def execute_function
        init_channel(params['id'])
        if !@channel.nil?
            res = Typhoeus.post("http://13.235.114.190:8080/function/#{@channel.uuid}")
            if res.code == 200
                render json: {payload: res.body}
            else
                render json: {error: res.body}, status: :unprocessable_entity
            end
        end
    end

    def webhook
        init_channel(params['id'])
        if !@channel.nil?
            # check if function exists
            res = Typhoeus.get("http://13.235.114.190:8080/function/#{@channel.uuid}")
            if res.code == 404
             # if no generate function
                create_openfaas_function(@channel)
            end
            res = Typhoeus.post("http://13.235.114.190:8080/function/#{@channel.uuid}", body: params.to_json)
            if res.code == 200
                transformed_payload = JSON.parse(res.body.squish.gsub("'","\""))
            else 
                transformed_payload = res.body.squish
            end
            if res.code == 200
                # hit target url
                res2 = Typhoeus.post("#{@channel.target}", body: JSON.dump(transformed_payload["body"]) )
            end
              
            # record activity
            event = History.new(channel_id: @channel.id, success: res.code == 200, transformed_payload: transformed_payload.to_json, payload: params.to_json)
            if !res2.nil? && res2.code == 200
                event.metadata = {target_payload: res2.body, target_response_code: res2.code}
            end
            event.save
        end
        render json: { ok: true }
    end

    def history
        init_channel(params['id'])
        @history = History.where(channel_id: @channel.id).order('created_at DESC').all
        render json: @history
    end

    def stats
        init_channel(params['id'])
        res = @channel.histories.group_by_hour_of_day(:created_at, format: "%-l %P", reverse: true).count
        render json: res
    end

    private
    def create_openfaas_function(channel)
        lang="python3"
        handler="handler.py"
        if channel.language == 'javascript'
            lang="node"
            handler="handler.js"
        end
        # create docker template
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
    end

    def init_channel(id)
        @channel = Channel.where(uuid: id).first
    end

    def channel_params
        params.permit(
          :target, :function, :language
        )
    end
end
