# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

parts = Part.create([
	{ label: 'Introduction', sorting: 0 },
	{ label: 'Part I. Defining the Digital Humanities', sorting: 1 },
	{ label: 'Part II. Theorizing the Digital Humanities', sorting: 2 },
	{ label: 'Part III. Critiquing the Digital Humanities', sorting: 3 },
	{ label: 'Part IV. Practicing the Digital Humanities', sorting: 4 },
	{ label: 'Part V. Teaching the Digital Humanities', sorting: 5 },
	{ label: 'Part VI. Envisioning the Future of the Digital Humanities', sorting: 6 }
])