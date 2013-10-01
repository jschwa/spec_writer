class PtController < ApplicationController

  before_filter :authenticate_user!

  def submit_auth
    update_pt_info
    @projects_list = pt_client.projects_list
    @projects_list
  end

  def submit_project_selection
    update_pt_info
    pt_client.create_stories(@page)
  end

  private

  def update_pt_info
    @page = Page.find(params[:page_id])
    @page.update_attributes(pt_info_attributes: params[:pt_info])
  end

  def pt_client
    PTClient.new(@page.pt_info.api_key)
  end

end
