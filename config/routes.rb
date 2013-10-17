SpecWriter::Application.routes.draw do
  devise_for :users

  resources :pages do
    post "/reorder_items" => "pages#reorder_items"
    get "/item_form/:item_type" => "items#item_form", as: :item_form
    get "/public" => "items#index_read_only"
    put "/toggle_public" => "items#toggle_public"
    put "/sync_with_pt" => "items#sync_with_pt"
    resources :items
    get "/cancel_edit"  => "pages#cancel_edit"
    post "/sync_with_pt_auth" => "pt#submit_auth"
    post "/sync_with_pt_project_selection" => "pt#submit_project_selection"
  end


  get "public/how_to"

  root :to => 'public#index'



end
