Rails.application.routes.draw do
  # Routes for the Comment resource:

  # CREATE
  post("/insert_comment", { :controller => "comments", :action => "create" })

  # READ
  get("/comments", { :controller => "comments", :action => "index" })

  get("/comments/:path_id", { :controller => "comments", :action => "show" })

  # UPDATE

  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })

  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the Like resource:

  # CREATE
  post("/insert_like", { :controller => "likes", :action => "create" })

  # READ
  get("/likes", { :controller => "likes", :action => "index" })

  get("/likes/:path_id", { :controller => "likes", :action => "show" })

  # UPDATE

  post("/modify_like/:path_id", { :controller => "likes", :action => "update" })

  # DELETE
  get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  #------------------------------

  # Routes for the Photo resource:

  # CREATE
  post("/insert_photo", { :controller => "photos", :action => "create" })

  # READ
  get("/photos", { :controller => "photos", :action => "index" })

  get("/photos/:path_id", { :controller => "photos", :action => "show" })

  # UPDATE

  post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })

  # DELETE
  get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
