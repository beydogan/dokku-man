module InteractorLogger
  extend ActiveSupport::Concern

  included do
    before do
      Rails.logger.info("#{tag} Started")
      Rails.logger.info("#{tag} Params: #{self.context}")
    end

    after do
      Rails.logger.info("#{tag} Completed")
    end

    def tag
      "[#{self.class.name}]"
    end
  end
end
