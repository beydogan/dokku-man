module DokkuAPI
  def api
    @dokku_api || @dokku_api = DokkuAPIClient.new(self.endpoint, self.api_key, self.api_secret)
  end
end
