class FeaturesController < ApplicationController

  def index
    @page = Page.find(params[:page_id])
    @feature = Feature.new
    @list_features = @page.features
  end

  def create
    @page = Page.find(params[:page_id])
    @feature = Feature.new(params[:feature].merge(position: @page.features.count))
    if @page.features << @feature
      render :feature_created
    else
      render :feature_invalid
    end
  end

end