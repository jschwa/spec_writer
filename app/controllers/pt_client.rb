class PTClient

  PROJECTS_URL = "http://www.pivotaltracker.com/services/v3/projects"

  def projects_list
    http = Curl.get(PROJECTS_URL) do |http|
      http.headers['X-TrackerToken'] = '5e0bbf1e56fd275a1c83a19468b5e559'
    end
    Hash.from_xml(http.body_str)["projects"]
  end

end