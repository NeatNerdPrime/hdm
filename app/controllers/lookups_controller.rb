class LookupsController < ApplicationController
  before_action :load_environments
  before_action :load_nodes
  before_action :load_keys

  def show
    @result = @key.lookup(@node)
    lookup_in_original_environment if @node.environment != @environment
  rescue Hdm::Error => e
    @error = e

    render action: "error"
  end

  private

  def load_keys
    @keys = Key.all_for(@node, environment: @environment)
    @keys.select! { |k| current_user.may_access?(k) }
    @key = Key.new(name: params[:key_id], hiera_data: @environment.hiera_data)
    authorize! :show, @key
  end

  def lookup_in_original_environment
    original_key = Key.new(name: params[:key_id], hiera_data: @node.environment.hiera_data)
    @original_result = original_key.lookup(@node)
  end
end
