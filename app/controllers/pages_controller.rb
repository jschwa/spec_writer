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
      redirect_to page_items_path(@page)
    else
      render :new
    end
  end

  def reorder_items
    Page.find(params[:page_id]).reorder_items(params[:new_order])
    render nothing: true
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to pages_path
  end

  def cancel_edit
    @page = Page.find(params[:page_id])
  end


end
