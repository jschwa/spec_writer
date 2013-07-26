class ItemsController < ApplicationController

  before_filter :authenticate_user!, :assign_page, except: [:index_read_only]
  before_filter :assign_item, only: [:edit, :update, :destroy]

  def item_form
    item_class = params[:item_type].constantize
    @item = Item.new(position: params[:item_position], itemizable: item_class.new())
  end

  def index
    @list_items = @page.items
  end

  def index_read_only
    @page = Page.where(public: true, id: params[:page_id]).first
    @list_items = @page.items
  end

  def toggle_public
    @page.toggle_public
  end

  def create
    @item = Item.new(params[:item])
    if @page.add_item(@item)
      render :item_created
    else
      render :item_invalid
    end
  end

  def edit
    @item.set_default_values
  end

  def update
    if @page.update_item(@item, params[:item])
      render :item_updated
    else
      render :item_update_invalid
    end
  end

  def destroy
    @page.destroy_item(@item)
  end

  def sync_with_pt
    @projects = PTClient.new.projects_list
    render :show_project_select
  end

  private

  def assign_page
    @page = current_user.pages.find(params[:page_id])
  end

  def assign_item
    @item = @page.items.find(params[:id])
  end

end