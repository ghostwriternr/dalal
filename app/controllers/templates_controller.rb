class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :update, :destroy]

  # GET /templates
  def index
    @templates = Template.all

    render json: @templates
  end
end
