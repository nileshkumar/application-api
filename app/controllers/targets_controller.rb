class TargetsController < ApplicationController
  def index
    @appliances = Appliance.includes(:targets)
    Target.update_reachable_targets(@appliances)
  end
end
