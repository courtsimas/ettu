module Ettu
  module FreshWhen
    extend ActiveSupport::Concern

    included do
      alias_method :old_fresh_when, :fresh_when

      def fresh_when(record_or_options, additional_options = {})
        ettu = Ettu.new(record_or_options, additional_options)

        etags = [*ettu.response_etag]
        etags << ettu.view_etag
        if request.format.try(:html?)
          etags << ettu.js_etag
          etags << ettu.css_etag
        end

        ettu_params = {etag: etags, last_modified: ettu.last_modified}

        old_fresh_when ettu.options.merge(ettu_params)
      end

    end
  end
end