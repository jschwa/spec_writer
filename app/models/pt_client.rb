class PTClient

  PROJECTS_URL = "/projects"
  STORIES_URL = "/projects/{project_id}/stories"

  def initialize api_key
    @api_key = api_key
  end

  #b46cfe2001c81fb4e4f2d5c99ef67a58
  def projects_list
    http = Curl.get(pt_url(PROJECTS_URL)) do |http|
      http.headers['X-TrackerToken'] = @api_key
        http.ssl_verify_peer = false
      end
    JSON.parse(http.body_str)
  end

  def create_stories page
    page.items.each do |item|
      if item.feature?
        if page.pt_info.separate_front_end_from_back_end?
          create_story(page, item, :front_end)
          create_story(page, item, :back_end)
        else
          create_story(page, item)
        end
      end
    end
  end

  def create_story page, item, description_type = nil
    feature = item.itemizable
    story_params = {
      project_id: page.pt_info.project_id,
      name: feature_title(feature),
      labels: [{
        name: page.name
      }],
      description: feature_description(feature, description_type),
      story_type: "feature"
    }
    http = Curl.post(pt_url(STORIES_URL.gsub("{project_id}", story_params[:project_id].to_s)), story_params.to_json) do |http|
      http.headers['X-TrackerToken'] = @api_key
      http.headers['Content-Type'] = 'application/json'
      http.ssl_verify_peer = false
    end
    http
  end

  private

  def pt_url url
    "https://www.pivotaltracker.com/services/v5#{url}"
  end

  def feature_description(feature, description_type)
    if description_type.nil?
      "" "
      FRONTEND

      #{feature.front_end}

      BACKEND

      #{feature.back_end}

      " ""
    else
      feature.send(description_type)
    end
  end

  def feature_title feature
    feature.title.blank? ? "Untitled #{feature.id}" : feature.title
  end

end