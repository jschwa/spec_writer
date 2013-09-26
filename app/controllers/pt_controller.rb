class PtController < ApplicationController

  before_filter :authenticate_user!

  def submit_auth
    update_pt_info
    @projects_list = PTClient.new(@page.pt_info.api_key).projects_list
    @projects_list
  end

  def submit_project_selection
    update_pt_info
  end

  private

  def update_pt_info
    @page = Page.find(params[:page_id])
    @page.update_attributes(pt_info_attributes: params[:pt_info])
  end

end
