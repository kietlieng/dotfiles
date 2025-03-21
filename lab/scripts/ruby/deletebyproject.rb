project = Project.find_by_full_path('development/application/integration/mobile/msdk')
builds =  project.builds
admin_user = User.find_by(username: 'klieng')
builds.where("finished_at < ?", 1.year.ago).each_batch do |batch|
  batch.each do |build|
    print "Ci::Build ID #{build.id}... "

    if build.erasable?
      Ci::BuildEraseService.new(build, admin_user).execute
      puts "Erased"
    else
      puts "Skipped (Nothing to erase or not erasable)"
    end
  end
end
