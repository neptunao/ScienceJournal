# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#roles
Role.create(name: :guest)
Role.create(name: :author)
Role.create(name: :censor)
Role.create(name: :admin)

#Authors
author1 = Author.create(first_name: 'Alexander', middle_name: 'Alexandrovich', last_name: 'Alexandrov')
author2 = Author.create(first_name: 'Vladimir', middle_name: 'Vladimirovich', last_name: 'Vladimirov')
author3 = Author.create(first_name: 'Maxim', middle_name: 'Maximovich', last_name: 'Maximov')

#Censors
censor1 = Censor.create(first_name: 'Alexander', middle_name: 'Vladimirovich', last_name: 'Censor', post: 'rector', degree: 'M.D.')
censor2 = Censor.create(first_name: 'Sergey', middle_name: 'Alexandrvich', last_name: 'Censor', post: 'assistent', degree: 'P.D.')

#users

User.create!(name: 'admin', email: 'duxcomus@mail.ru', password: 'adminadmin',
                     password_confirmation: 'adminadmin', role_ids: [Role.admin_role.id])

author_user = User.create!(name: 'author', email: 'author1@mail.ru', password: '123456',
                     password_confirmation: '123456', role_ids: [Role.guest_role.id ,Role.author_role.id])
author_user.update_attribute(:person, author1)

author_user1 = User.create!(name: 'author2', email: 'author2@mail.ru', password: '123456',
                     password_confirmation: '123456', role_ids: [Role.guest_role.id ,Role.author_role.id])
author_user1.update_attribute(:person, author2)

censor_user = User.create!(name: 'censor', email: 'censor@mail.ru', password: '123456',
                     password_confirmation: '123456', role_ids: [Role.guest_role.id ,Role.censor_role.id])
censor_user.update_attribute(:person, censor1)

censor_user2 = User.create!(name: 'censor1', email: 'censor1@mail.ru', password: '123456',
                     password_confirmation: '123456', role_ids: [Role.guest_role.id ,Role.censor_role.id])
censor_user2.update_attribute(:person, censor2)
censor_user2.update_attribute(:is_approved, true)

#data_files
article_file = DataFile.create(filename: '1test1', tag: Article::ARTICLE_FILE_TAG)
resume_rus_file = DataFile.create(filename: '2test2', tag: Article::RESUME_RUS_FILE_TAG)
resume_eng_file = DataFile.create(filename: '3test3', tag: Article::RESUME_ENG_FILE_TAG)
cover_note_file = DataFile.create(filename: '4test4', tag: Article::COVER_NOTE_FILE_TAG)
data_files = [article_file, resume_rus_file, resume_eng_file, cover_note_file]

#Categories
root = Category.create(title: 'Machine Learning')
child1 = Category.create(title: 'Coding')
top1 = Category.create(title: 'Data Mining')
top2 = Category.create(title: 'Chemistry')
top1.children = [child1]
root.children = [top1, top2]
Category.rebuild!

#articles
ar = Article.create!(title: 'Coding at machine learning', data_files: data_files, author_ids: [author1.id], category_id: root.id, status: Article::STATUS_PUBLISHED)
ar1 = Article.new(title: 'Chemistry at coding', author_ids: [author1.id, author2.id, author3.id], status: Article::STATUS_PUBLISHED, category_id: child1.id)
ar1.update_attribute(:data_files, [DataFile.create(filename: '11test11', tag: Article::ARTICLE_FILE_TAG),
                                   DataFile.create(filename: '21test12', tag: Article::RESUME_RUS_FILE_TAG),
                                   DataFile.create(filename: '31test13', tag: Article::RESUME_ENG_FILE_TAG),
                                   DataFile.create(filename: '41test14', tag: Article::COVER_NOTE_FILE_TAG)])
ar1.save!
ar2 = Article.new(title: 'Coding and refactoring', author_ids: [author2.id, author3.id], status: Article::STATUS_CREATED, category_id: child1.id)
ar2.update_attribute(:data_files, [DataFile.create(filename: '111test11', tag: Article::ARTICLE_FILE_TAG),
                                   DataFile.create(filename: '211test12', tag: Article::RESUME_RUS_FILE_TAG),
                                   DataFile.create(filename: '311test13', tag: Article::RESUME_ENG_FILE_TAG),
                                   DataFile.create(filename: '411test14', tag: Article::COVER_NOTE_FILE_TAG)])

ar2.save!

ar3 = Article.new(title: 'Review test', author_ids: [author2.id, author3.id], status: Article::STATUS_TO_REVIEW, category_id: child1.id, censor_id: censor1.id)
ar3.update_attribute(:data_files, [DataFile.create(filename: '111test111', tag: Article::ARTICLE_FILE_TAG),
                                   DataFile.create(filename: '211test121', tag: Article::RESUME_RUS_FILE_TAG),
                                   DataFile.create(filename: '311test113', tag: Article::RESUME_ENG_FILE_TAG),
                                   DataFile.create(filename: '411test141', tag: Article::COVER_NOTE_FILE_TAG)])

ar3.save!

ar4 = Article.new(title: 'Review test1', author_ids: [author2.id, author3.id], status: Article::STATUS_TO_REVIEW, category_id: child1.id, censor_id: censor2.id)
ar4.update_attribute(:data_files, [DataFile.create(filename: '111test1121', tag: Article::ARTICLE_FILE_TAG),
                                   DataFile.create(filename: '211test1221', tag: Article::RESUME_RUS_FILE_TAG),
                                   DataFile.create(filename: '311test1132', tag: Article::RESUME_ENG_FILE_TAG),
                                   DataFile.create(filename: '411test1412', tag: Article::COVER_NOTE_FILE_TAG)])

ar4.save!

ar5 = Article.new(title: 'Review test2', author_ids: [author2.id, author3.id], status: Article::STATUS_REVIEWED, category_id: child1.id, censor_id: censor2.id)
ar5.update_attribute(:data_files, [DataFile.create(filename: '1121test1121', tag: Article::ARTICLE_FILE_TAG),
                                   DataFile.create(filename: '2211test1221', tag: Article::RESUME_RUS_FILE_TAG),
                                   DataFile.create(filename: '3121test1132', tag: Article::RESUME_ENG_FILE_TAG),
                                   DataFile.create(filename: '4121test1412', tag: Article::COVER_NOTE_FILE_TAG),
                                   DataFile.create(filename: '1review1', tag:Article::REVIEW_FILE_TAG)])

ar5.save!

#journals
Journal.create!(name: 'Data Mining chemistry', num: 1, category_id: root.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '212test232', tag: Journal::JOURNAL_FILE_TAG)])
Journal.create!(name: 'Data Mining chemistry', num: 2, category_id: root.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '212test22', tag: Journal::JOURNAL_FILE_TAG),
                             DataFile.create(filename: 'data/seed_cover2.jpg', tag: Journal::COVER_IMAGE_FILE_TAG)])
Journal.create!(name: 'Data Mining coding', num: 1, category_id: child1.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '222test22', tag: Journal::JOURNAL_FILE_TAG),
                             DataFile.create(filename: 'data/seed_cover3.jpg', tag: Journal::COVER_IMAGE_FILE_TAG)])
Journal.create!(name: 'Data Mining coding', num: 2, category_id: child1.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '223test22', tag: Journal::JOURNAL_FILE_TAG),
                             DataFile.create(filename: 'data/seed_cover4.jpg', tag: Journal::COVER_IMAGE_FILE_TAG)])
Journal.create!(name: 'Data Mining coding', num: 3, category_id: child1.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '224test22', tag: Journal::JOURNAL_FILE_TAG),
                             DataFile.create(filename: 'data/seed_cover5.png', tag: Journal::COVER_IMAGE_FILE_TAG)])
Journal.create!(name: 'Coding at chemistry', num: 1, category_id: top2.id, article_ids: [ar.id, ar1.id],
                data_files: [DataFile.create(filename: '22test22', tag: Journal::JOURNAL_FILE_TAG),
                             DataFile.create(filename: 'data/seed_cover1.jpg', tag: Journal::COVER_IMAGE_FILE_TAG)])