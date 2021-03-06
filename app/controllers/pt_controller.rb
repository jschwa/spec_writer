class PtController < ApplicationController

  before_filter :authenticate_user!

  def pt_sync
    @page = Page.find(params[:page_id])
    if @page.has_pt_info?
      render :resync
    else
      render :first_sync
    end
  end

  def pt_resync
    @page = Page.find(params[:page_id])
    start_sync
    assign_items
    render :sync_complete
  end

  def submit_auth
    begin
      update_pt_info
      @projects_list = pt_client.projects_list
    rescue Exception => e
      @pt_error = e.to_s
    end
  end

  def submit_project_selection
    update_pt_info
    start_sync
    assign_items
    render :sync_complete
  end

  def pt_edit_settings
    @page = Page.find(params[:page_id])
    render :first_sync
  end

  private

  def update_pt_info
    @page = Page.find(params[:page_id])
    @page.update_attributes(pt_info_attributes: params[:pt_info])
  end

  def pt_client
    PTClient.new(@page.pt_info.api_key)
  end

  def start_sync
    begin
      pt_client.sync_stories(@page)
    rescue Exception => e
      @pt_error = e.to_s
      logger.error e
      logger.error e.backtrace.join("\n")
    end
  end

  def assign_items
    @list_items = @page.items
  end

end
