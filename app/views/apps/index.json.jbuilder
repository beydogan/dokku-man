json.array!(@apps) do |app|
  json.extract! app, :id, :name, :url, :server_id
  json.url app_url(app, format: :json)
end
