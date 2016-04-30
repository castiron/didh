# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

e1 = Edition.where(label: '2012 Print Edition', sorting: 100).first_or_create
e2 = Edition.where(label: '2016 Print Edition', sorting: 99).first_or_create

Part.where(label: 'Introduction', sorting: 0, edition: e1).first_or_create
Part.where(label: 'Part I. Defining the Digital Humanities', sorting: 1, edition: e1).first_or_create
Part.where(label: 'Part II. Theorizing the Digital Humanities', sorting: 2, edition: e1).first_or_create
Part.where(label: 'Part III. Critiquing the Digital Humanities', sorting: 3, edition: e1).first_or_create
Part.where(label: 'Part IV. Practicing the Digital Humanities', sorting: 4, edition: e1).first_or_create
Part.where(label: 'Part V. Teaching the Digital Humanities', sorting: 5, edition: e1).first_or_create
Part.where(label: 'Part VI. Envisioning the Future of the Digital Humanities', sorting: 6, edition: e1).first_or_create

Part.where(label: 'Introduction', sorting: 0, edition: e2).first_or_create
Part.where(label: 'Histories and Futures of the Digital Humanities', sorting: 1, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Methods', sorting: 2, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Practices', sorting: 3, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and the Disciplines', sorting: 4, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Critics', sorting: 5, edition: e2).first_or_create
Part.where(label: 'Forum: Text Analysis at Scale', sorting: 6, edition: e2).first_or_create