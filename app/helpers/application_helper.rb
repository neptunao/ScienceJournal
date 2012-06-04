module ApplicationHelper
  def current_person_id
    (current_user && current_user.person) ? current_user.person.id : nil
  end

  def articles_link(params)
    if current_user.person && current_user.person.valid?  #TODO test
      articles_path(params)
    else
      flash[:notice] = 'You must fill personal information before.'
      edit_personal_path
    end
  end

  def data_file_url(filename)
    "#{root_url}#{filename}"
  end
end
