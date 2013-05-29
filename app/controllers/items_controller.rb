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

  def edit
    @page = Page.find(params[:page_id])
    @item = Item.find(params[:id])
  end

  def update
    @page = Page.find(params[:page_id])
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      render :item_updated
    else
      render :item_update_invalid
    end
  end

  def destroy
    @page = Page.find(params[:page_id])
    @item = Item.find(params[:id])
    @page.destroy_item(@item)
  end

end