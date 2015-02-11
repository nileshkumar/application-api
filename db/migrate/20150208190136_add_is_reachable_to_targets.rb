class AddIsReachableToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :is_reachable, :boolean, :default => false
  end
end
