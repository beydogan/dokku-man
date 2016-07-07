json.array!(@app_configs) do |app_config|
  json.extract! app_config, :id, :name, :value, :app_id
  json.url app_config_url(app_config, format: :json)
end
