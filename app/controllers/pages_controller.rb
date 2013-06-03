class PagesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @pages = current_user.pages
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if current_user.pages << @page
      redirect_to pages_path
    else
      render :new
    end
  end

  def reorder_items
    Page.find(params[:page_id]).reorder_items(params[:new_order])
    render nothing: true
  end


end
