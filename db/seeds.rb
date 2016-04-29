# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

raise "You probably don't really want to seed again; you already have editions in the db!" if Edition.count > 0

Edition.create([
  { label: '2012 Print Edition'},
  { label: '2016 Print Edition'}
])

# 1st edition parts
Part.create([
	{ label: 'Introduction', sorting: 0, edition_id: 1 },
	{ label: 'Part I. Defining the Digital Humanities', sorting: 1, edition_id: 1 },
	{ label: 'Part II. Theorizing the Digital Humanities', sorting: 2, edition_id: 1 },
	{ label: 'Part III. Critiquing the Digital Humanities', sorting: 3, edition_id: 1 },
	{ label: 'Part IV. Practicing the Digital Humanities', sorting: 4, edition_id: 1 },
	{ label: 'Part V. Teaching the Digital Humanities', sorting: 5, edition_id: 1 },
	{ label: 'Part VI. Envisioning the Future of the Digital Humanities', sorting: 6, edition_id: 1 }
])

# 2nd edition parts
Part.create([
	{ label: 'Introduction', sorting: 0, edition_id: 2 },
	{ label: 'Histories and Futures of the Digital Humanities', sorting: 1, edition_id: 2 },
	{ label: 'Digital Humanities and Its Methods', sorting: 2, edition_id: 2 },
	{ label: 'Digital Humanities and Its Practices', sorting: 3, edition_id: 2 },
	{ label: 'Digital Humanities and the Disciplines', sorting: 4, edition_id: 2 },
	{ label: 'Digital Humanities and Its Critics', sorting: 5, edition_id: 2 },
	{ label: 'Forum: Text Analysis at Scale', sorting: 6, edition_id: 2 }
])