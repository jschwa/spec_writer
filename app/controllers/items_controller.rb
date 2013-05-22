class ItemsController < ApplicationController

  def item_form
    @page = Page.find(params[:page_id])
    item_class = params[:item_type].constantize
    @item = Item.new(position: @page.items.size, itemizable: item_class.new())
  end

  def index
    @page = Page.find(params[:page_id])
    @list_items = @page.items
  end

  def create
    @page = Page.find(params[:page_id])
    @item = Item.new(params[:item])
    if @page.items << @item
      render :item_created
    else
      render :item_invalid
    end
  end

end