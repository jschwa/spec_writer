class PtController < ApplicationController

  before_filter :authenticate_user!

  def submit_auth
    @page = Page.find(params[:page_id])
    @page.update_attributes(pt_info_attributes: params[:pt_info])
  end

end
