module ArticlesHelper
  def status_str
    case @article.status
      when Article::STATUS_CREATED then 'Created'
      when Article::STATUS_TO_REVIEW then 'Waiting for review'
      when Article::STATUS_REVIEWED then 'Reviewed'
      when Article::STATUS_APPROVED then 'Approved by editor and prepare to be published'
    end
  end
end