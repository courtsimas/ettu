module Ettu
  class Railtie < Rails::Railtie
    initializer 'install' do
      require 'ettu'

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, FreshWhen
      end
    end
  end
end
