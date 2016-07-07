json.array!(@hosts) do |host|
  json.extract! host, :id, :name, :addr, :private_key, :public_key
  json.url host_url(host, format: :json)
end
