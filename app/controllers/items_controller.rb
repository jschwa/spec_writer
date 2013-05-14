class ItemsController < ApplicationController

  def index
    @page = Page.find(params[:page_id])
    @feature_item = Item.new(position: @page.items.size, itemizable: Feature.new())
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