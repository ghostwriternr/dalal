class ChannelsController < ApplicationController
    def show
        @channel = Channel.where(uuid: params['id']).first
        render json: @channel || {} 
    end

    def create
        @channel = Channel.new(uuid: SecureRandom.hex(10), target: '')
        if @channel.save
            render json: @channel, status: :created
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    def update
        @channel = Channel.where(uuid: params['id']).first
        if @channel.update(channel_params)
            render json: @channel
        else
            render json: @channel.errors, status: :unprocessable_entity
        end
    end

    private
    def channel_params
        params.require(:channel).permit(
          :target
        )
    end
end
