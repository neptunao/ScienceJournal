module JournalsHelper
  def journal_cover(journal)
    if journal.cover_image
      image_tag "../#{journal.cover_image.filename}", size: '90x120'
    else
      image_tag 'not_avaliable.jpeg', size: '90x120'
    end
  end
end