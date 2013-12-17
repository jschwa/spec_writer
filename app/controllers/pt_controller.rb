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
    render :sync_complete
  end

  def submit_auth
    update_pt_info
    @projects_list = pt_client.projects_list
  end

  def submit_project_selection
    update_pt_info
    start_sync
    render :sync_complete
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
      pt_client.create_stories(@page)
    rescue Exception => e
      @pt_error = e.to_s
    end
  end

end
