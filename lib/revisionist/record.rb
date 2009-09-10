module Revisionist
	module Record

		def self.included(base)
			base.send :extend, ClassMethods
		end

		module ClassMethods
			def revision_attributes
				@@revision_attributes ||= []
			end
			def revision_attributes=(attributes)
				@@revision_attributes = attributes
			end
			def revisionable(attributes=[], options={})
				attributes = [attributes] unless attributes.kind_of?(Array)
				self.revision_attributes += attributes.map{|a| a.to_sym}

				class_eval <<-end_eval
					has_many :revisions, :as => :revisionable, :order => 'created_at ASC'
					attr_accessor :revision_info, :revisionist
					
					before_update do |obj|
						if obj.valid?
							changed_attributes = obj.changed.map{|a| a.to_sym}.select{|a| obj.class.revision_attributes.include?(a)}
							changed_attributes.each do |attribute|
								revision_params = {
									:revisionable => obj,
									:name         => attribute.to_s,
									:old_value    => obj.changes[attribute.to_s].first,
									:new_value    => obj.changes[attribute.to_s].last,
									:info         => obj.revision_info,
									:revisionist  => obj.revisionist
								}
								Revision.create(revision_params)
							end
						end
					end
				end_eval

				send :include, InstanceMethods
			end 
		end

		module InstanceMethods
			def revisions_on(attribute, options={})
				revisions = self.revisions.select{|r| r.name == attribute.to_s}
				if options[:since]
					revisions = revisions.select{|r| r.created_at > options[:since]}
				end
				revisions
			end
			def revisions_on?(attribute, options={})
				(self.revisions_on(attribute, options).length > 0) ? true : false
			end
		end
	end
end