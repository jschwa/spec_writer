module PtHelper

  def projects_select_options
    options = {}
    @projects_list.each do |project|
      options[project["name"]] = project.to_json
    end
    options
  end

end
