class PagesController < ApplicationController

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to pages_path
    else
      render :new
    end
  end

  def reorder_features
    Page.find(params[:page_id]).reorder_features(params[:new_order])
    render nothing: true
  end

end
