module ArticlesHelper
  def status_str
    case @article.status
      when Article::STATUS_CREATED then 'Created'
      when Article::STATUS_TO_REVIEW then 'Waiting for review'
      when Article::STATUS_REVIEWED then 'Reviewed'
      when Article::STATUS_APPROVED then 'Approved by editor and prepare to be published'
      when Article::STATUS_REJECTED then 'Rejected by editor'
      when Article::STATUS_REJECTED_BY_CENSOR then 'Rejected by censor and waiting for editor decision'
      when Article::STATUS_PUBLISHED then 'Published'
      else raise 'unknown status'
    end
  end

  def censor_article?
    person? && !(current_user.role?(:censor) && @article.censor_id == current_user.person.id)
  end
end