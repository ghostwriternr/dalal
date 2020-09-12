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
            render json: @channel
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    def generate_function
        init_channel(params['id'])
        if !@channel.nil?
            # delete files if exist

            # create docker template
            data = `cd functions && faas-cli new --lang python3 #{@channel.uuid}`
            puts data

            # update handler.py
            File.delete("functions/#{@channel.uuid}/handler.py")
            file = File.open("functions/#{@channel.uuid}/handler.py", "w")
            file.puts @channel.function
            file.close

            # create 
            data = `cd functions && faas-cli up -f #{@channel.uuid}.yml`
            puts data
            # delete files
            FileUtils.rm_rf("functions/#{@channel.uuid}")
            FileUtils.rm_rf("functions/build/#{@channel.uuid}")
            File.delete("functions/#{@channel.uuid}.yml")
            render json: { ok: true }
        end
    end

    def execute_function
        init_channel(params['id'])
        if !@channel.nil?
            res = Typhoeus.post("http://13.235.114.190:8080/function/#{@channel.uuid}")
            render json: {payload: res.body}
        end
    end

    private
    def init_channel(id)
        @channel = Channel.where(uuid: id).first
    end

    def channel_params
        params.permit(
          :target, :function, :language
        )
    end
end
