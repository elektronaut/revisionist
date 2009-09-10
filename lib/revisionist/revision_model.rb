module Revisionist
	class RevisionModel < ActiveRecord::Base
		unloadable
		belongs_to :revisionable, :polymorphic => true
		belongs_to :revisionist, :polymorphic => true
	end
end