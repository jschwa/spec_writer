class PTClient

  PROJECTS_URL = "/projects"
  STORIES_URL = "/projects/{project_id}/stories"
  FRONTEND_MARKER = "=== FRONTEND [don't change this line] ==="
  BACKEND_MARKER = "=== BACKEND [don't change this line] ==="

  def initialize api_key
    @api_key = api_key
  end

  #b46cfe2001c81fb4e4f2d5c99ef67a58
  def projects_list
    JSON.parse(pt_request(PROJECTS_URL))
  end

  def create_stories page
    page.items.each do |item|
      if item.feature?
        if page.pt_info.separate_front_end_from_back_end?
          create_story(page, item, :front_end) unless item.itemizable.front_end.blank?
          create_story(page, item, :back_end) unless item.itemizable.back_end.blank?
          item.touch
        else
          create_story(page, item)
        end
      end
    end
  end

  private

  def pt_request url, method = :get, params = {}
    params = params.to_json unless method == :get
    http = Curl.send(method, pt_url(url), params) do |http|
      http.headers['X-TrackerToken'] = @api_key
      http.ssl_verify_peer = false
      http.headers['Content-Type'] = 'application/json' unless method == :get
    end
    if http.status == "200 OK"
      http.body_str
    else
      response = JSON.parse(http.body_str)
      response = response["data"] if response["data"]
      raise "#{response["error"]} #{response["general_problem"]}"
    end
  end

  def create_story page, item, description_type = nil
    existing_story = existing_pt_item(item, description_type)
    if existing_story.nil?
      feature = item.itemizable
      story_params = {
        project_id: page.pt_info.project_id,
        story_type: "feature"
      }
      story_params = story_params.merge(page.pt_info.separate_front_end_from_back_end? ? separate_story_params(page, feature, description_type) : single_story_params(page, feature))
      response = pt_request(STORIES_URL.gsub("{project_id}", story_params[:project_id].to_s), :post, story_params)
      item.add_pt_item_info(response, description_type)
    else
      update_story(page, item, existing_story, description_type)
    end
  end

  def update_story page, item, existing_story, description_type = nil?
    if Time.parse(existing_story["updated_at"]) < item.updated_at
      feature = item.itemizable
      story_params = {
        story_type: "feature",
      }
      story_params = story_params.merge(page.pt_info.separate_front_end_from_back_end? ? separate_story_params(page, feature, description_type) : single_story_params(page, feature))
      response = pt_request(STORIES_URL.gsub("{project_id}", page.pt_info.project_id.to_s)+"/#{item.pt_item_for(description_type).story_id}", :put, story_params)
      item.update_pt_item_info(response)
    else
      update_story_from_pt(page, item, existing_story, description_type)
    end
  end

  def update_story_from_pt page, item, existing_story, description_type
    attributes_to_update = {title: existing_story["name"]}
    description = existing_story["description"]
    if description_type.nil?
      parts = description.split(BACKEND_MARKER)
      frontend = parts.first.gsub(FRONTEND_MARKER, "")
      backend = parts[1]
      attributes_to_update = attributes_to_update.merge(front_end: frontend, back_end: backend)
    else
      attributes_to_update[description_type] = description
    end
    item.itemizable.update_attributes(attributes_to_update)
    item.update_pt_item_info(existing_story.to_json)
  end

  def separate_story_params page, feature, description_type
    type_label = description_type.to_s.gsub("_", "")
    {
      name: feature.title.blank? ? "Untitled #{feature.id}" : "#{feature.title}",
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
      #{FRONTEND_MARKER}

      #{feature.front_end}

      #{BACKEND_MARKER}

      #{feature.back_end}
      "
    }
  end


  def pt_url url
    "https://www.pivotaltracker.com/services/v5#{url}"
  end

  def existing_pt_item(item, description_type)
    response = pt_request(STORIES_URL.gsub("{project_id}", item.page.pt_info.project_id.to_s))
    stories_json = JSON.parse(response)
    found_story_json = stories_json.find do |story_json|
      pt_item_info = item.pt_item_for(description_type)
      pt_item_info.same_story_id?(story_json) unless pt_item_info.nil?
    end
    found_story_json
  end

end