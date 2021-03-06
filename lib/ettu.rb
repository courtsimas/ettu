require 'active_support/concern'
require 'active_support/ordered_options'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/module/aliasing'

require 'ettu/version'
require 'ettu/configuration'
require 'ettu/fresh_when'
require 'ettu/railtie' if defined? Rails::Railtie


class Ettu
  attr_reader :options

  class << self
    @@config = Configuration.new

    def configure
      yield @@config
    end
  end

  def initialize(record_or_options = nil, additional_options = {}, controller = nil)
    @controller, @asset_etags = controller, {}
    if record_or_options.is_a? Hash
      @record, @options = nil, record_or_options
    else
      @record, @options = record_or_options, additional_options
    end
  end

  def etags
    etags = [*response_etag]
    etags << view_etag
    etags.concat asset_etags
    etags.compact
  end

  def last_modified
    @options.fetch(:last_modified, @record.try(:updated_at))
  end

  def response_etag
    @options.fetch(:etag, @record)
  end

  def view_etag
    default_view = @@config.fetch(:view, "#{@controller.controller_name}/#{@controller.action_name}")
    view = @options.fetch(:view, default_view)
    @view_etag ||= view_digest(view)
  end

  def asset_etags
    assets = @options.fetch(:assets, @@config.assets)
    [*assets].map { |asset| asset_etag(asset) }
  end

  private

  def asset_etag(asset)
    @asset_etags[asset] ||= asset_digest(asset)
  end

  # Jeremy Kemper
  # https://gist.github.com/jeremy/4211803
  def view_digest(view)
    return nil unless view.present?

    @@config.template_digestor.digest(
      view,
      @controller.request.format.try(:to_sym),
      @controller.lookup_context
    )
  end

  # Jeremy Kemper
  # https://gist.github.com/jeremy/4211803
  def asset_digest(asset)
    return nil unless asset.present?
    # Check already computed assets (production)
    if digest = ActionView::Base.assets_manifest.assets[asset]
      digest
    else
      # Compute it
      Rails.application.assets[asset].digest
    end
  end
end
