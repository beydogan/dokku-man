json.array!(@servers) do |server|
  json.extract! server, :id, :name, :addr, :private_key, :public_key
  json.url server_url(server, format: :json)
end
