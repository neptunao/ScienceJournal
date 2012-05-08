# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create!(name: 'admin', email: 'duxcomus@mail.ru', password: 'adminadmin',
                     password_confirmation: 'adminadmin')
admin.user_roles = [Role.create(name: :admin)]
root = Category.create(title: 'root')
child1 = Category.create(title: 'child1')
top1 = Category.create(title: 'top1')
top2 = Category.create(title: 'top2')
top1.children = [child1]
root.children = [top1, top2]