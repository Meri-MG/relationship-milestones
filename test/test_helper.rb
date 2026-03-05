require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers",     "app/helpers"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Disable parallelism so SimpleCov can merge results correctly
    # parallelize(workers: :number_of_processors)

    fixtures :all

    # Convenience: set up session with a relationship
    def sign_in_with_relationship(rel)
      session[:relationship_id] = rel.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def set_relationship_session(rel)
      get dashboard_path  # initialize session
      # Simulate the session the app sets via controller
      follow_redirect! if response.redirect?
    end
  end
end
