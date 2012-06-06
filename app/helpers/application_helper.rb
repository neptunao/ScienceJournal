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

  def person?
    current_user && current_user.person
  end

  def current_role?(role)
    current_user && current_user.role?(role)
  end
end
