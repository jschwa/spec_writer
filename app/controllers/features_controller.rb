class FeaturesController < ApplicationController

  def index
    @page = Page.find(params[:page_id])
    @feature = Feature.new
    @list_features = Feature.all
  end

  def create
    @page = Page.find(params[:page_id])
    @feature = Feature.new(params[:feature])
      if @page.features << @feature
        render :feature_created
      else
        render :feature_invalid
      end

  end

end