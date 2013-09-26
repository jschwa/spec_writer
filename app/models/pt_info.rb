class PtInfo < ActiveRecord::Base
  attr_accessible :api_key, :pt_json, :separate_front_end_from_back_end
end
