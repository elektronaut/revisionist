class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.references :revisionable, :polymorphic => true
      t.references :revisionist,  :polymorphic => true
      t.string     :name
      t.text       :info
      t.string     :old_value, :new_value
      t.datetime   :created_at
    end
  end

  def self.down
    drop_table :revisions
  end
end
