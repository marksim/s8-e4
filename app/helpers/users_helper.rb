module UsersHelper
  def github_account_link(github_account)
    unless github_account.blank?
      link_to github_account, "http://github.com/#{github_account}",
              :target => "_blank"
    end
  end

  def twitter_account_link(twitter_account)
     unless twitter_account.blank?
        link_to twitter_account, "http://twitter.com/#{twitter_account}",
                :target => "_blank"
      end
  end

  def github_project_link(project_url)
    unless project_url.blank?
      link_to project_url, project_url
    end
  end

  def user_since(user)
    if user.alumnus?
      [Date::MONTHNAMES[user.alumni_month], user.alumni_year].join(' ')
    else
      [Date::MONTHNAMES[user.created_at.month], user.created_at.year].join(' ')
    end
  end

  def user_type(user)
    if user.alumnus?
      "Alumnus: "
    elsif user.instructor_courses.any?
      "Instructor: "
    else
      "#{user.access_level.to_s.humanize}: "
    end
  end
  
  def user_icon(user, size=24)
    render :partial => "users/icon", :locals => {:user => user, :size => size}
  end
end
