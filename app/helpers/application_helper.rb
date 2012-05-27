module ApplicationHelper
  def pending_articles_link
    if current_user.person && current_user.person.valid?  #TODO test
      articles_path(status: Article::STATUS_TO_REVIEW, censor_id: current_user.person.id)
    else
      flash[:notice] = 'You must fill personal information before view pending articles.'
      edit_personal_path
    end
  end
end
