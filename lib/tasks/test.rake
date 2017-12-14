task :morning_contact => :environment do
    User.all.each do |user|

    user.morning_contact

    end
end
