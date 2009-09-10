class RevisionistGenerator < Rails::Generator::NamedBase
	def manifest
		record do |m|
			m.file 'models/revision.rb', 'app/models/revision.rb'
			m.file 'migrations/20090910042753_create_revisions.rb', 'db/migrate/20090910042753_create_revisions.rb'
		end
	end
end
