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
            create_openfaas_function(@channel.uuid, @channel.function)
            render json: @channel
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    def generate_function
        init_channel(params['id'])
        if !@channel.nil?
            create_openfaas_function(@channel.uuid, @channel.function)
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
                create_openfaas_function(@channel.uuid, @channel.function)
            end
            res = Typhoeus.post("http://13.235.114.190:8080/function/#{@channel.uuid}", body: params.to_json)
            transformed_payload = JSON.parse(res.body.squish.gsub("'","\""))
            
            if res.code == 200
                # hit target url
                res2 = Typhoeus.post("#{@channel.target}", body: JSON.dump(transformed_payload["body"]) )
                # record activity
                event = History.new(channel_id: @channel.id, success: res.code == 200, transformed_payload: transformed_payload.to_json, payload: params.to_json)
                event.save
            end
        end
        
    end

    def history
        init_channel(params['id'])
        @history = History.where(channel_id: @channel.id).all
        render json: @history
    end

    private
    def create_openfaas_function(uuid, function)
        # create docker template
        data = `cd functions && faas-cli new --lang python3 #{uuid}`
        puts data
        
        # update handler.py
        File.delete("functions/#{uuid}/handler.py")
        file = File.open("functions/#{uuid}/handler.py", "w")
        file.puts function
        file.close

        # create 
        data = `cd functions && faas-cli up -f #{uuid}.yml`
        puts data
        # delete files
        FileUtils.rm_rf("functions/#{uuid}")
        FileUtils.rm_rf("functions/build/#{uuid}")
        File.delete("functions/#{uuid}.yml")
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
