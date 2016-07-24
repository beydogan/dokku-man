class AppConfig < ApplicationRecord
  belongs_to :app, inverse_of: :app_configs, optional: true
end
