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
          create_story(page, item, :front_end) unless item.itemizable.front_end.blank?
          create_story(page, item, :back_end) unless item.itemizable.back_end.blank?
        else
          if item.pt_item_infos.empty? || !item_exists_in_pt?(item)
            item.pt_item_infos.destroy_all
            create_story(page, item)
          else
            update_story(page, item)
          end
        end
      end
    end
  end

  private

  def create_story page, item, description_type = nil
    feature = item.itemizable
    story_params = {
      project_id: page.pt_info.project_id,
      story_type: "feature"
    }
    story_params = story_params.merge(page.pt_info.separate_front_end_from_back_end? ? separate_story_params(page, feature, description_type) : single_story_params(page, feature))
    http = Curl.post(pt_url(STORIES_URL.gsub("{project_id}", story_params[:project_id].to_s)), story_params.to_json) do |http|
      http.headers['X-TrackerToken'] = @api_key
      http.headers['Content-Type'] = 'application/json'
      http.ssl_verify_peer = false
    end
    item.add_pt_item_info(http.body_str)
  end

  def update_story page, item, description_type = nil?
    feature = item.itemizable
    story_params = {
      story_type: "feature",
    }
    story_params = story_params.merge(page.pt_info.separate_front_end_from_back_end? ? separate_story_params(page, feature, description_type) : single_story_params(page, feature))
    http = Curl.put(pt_url(STORIES_URL.gsub("{project_id}", page.pt_info.project_id.to_s)+"/#{item.pt_item_infos.first.story_id}"), story_params.to_json) do |http|
      http.headers['X-TrackerToken'] = @api_key
      http.headers['Content-Type'] = 'application/json'
      http.ssl_verify_peer = false
    end
    item.update_pt_item_info(http.body_str)
  end

  def separate_story_params page, feature, description_type
    type_label = description_type.to_s.gsub("_", "")
    {
      name: feature.title.blank? ? "Untitled #{feature.id} #{type_label}" : "#{feature.title} #{type_label}",
      labels: [{name: page.name}, {name: type_label}],
      description: feature.send(description_type)
    }
  end

  def single_story_params page, feature
    {
      name: feature.title.blank? ? "Untitled #{feature.id}" : feature.title,
      labels: [{
        name: page.name
      }],
      description: "
       FRONTEND
 
       #{feature.front_end}
 
       BACKEND
 
       #{feature.back_end}
      "
    }
  end


  def pt_url url
    "https://www.pivotaltracker.com/services/v5#{url}"
  end

  def item_exists_in_pt?(item)
    http = Curl.get(pt_url(STORIES_URL.gsub("{project_id}", item.page.pt_info.project_id.to_s))) do |http|
      http.headers['X-TrackerToken'] = @api_key
      http.ssl_verify_peer = false
    end
    stories_json = JSON.parse(http.body_str)
    found_story_json = stories_json.find { |story_json| item.pt_item_infos.find { |pt_item_info| pt_item_info.same_story_id?(story_json) } }
    !found_story_json.nil?
  end

end