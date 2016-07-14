# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Just being careful about not creating duplicate records on production, while continuing to
# allow seeds to work on local dev envs
e1 = Edition.where(label: '2012 Print Edition').first_or_create
e1.sorting = 100
e1.save if e1.changed?

e2 = Edition.where(label: '2016 Print Edition', sorting: 99).first_or_create

edition_1_part_titles = [
    'Introduction',
    'Part I. Defining the Digital Humanities',
    'Part II. Theorizing the Digital Humanities',
    'Part III. Critiquing the Digital Humanities',
    'Part IV. Practicing the Digital Humanities',
    'Part V. Teaching the Digital Humanities',
    'Part VI. Envisioning the Future of the Digital Humanities'
]

i = 0
edition_1_part_titles.each do | title |
  p = Part.where(label: title).first_or_create
  p.edition = e1
  p.sorting = i
  p.save if p.changed?
  i += 1
end

# Being less careful about edition 2, since this will run on prod after migrations have run
Part.where(label: 'Introduction', sorting: 0, edition: e2).first_or_create
Part.where(label: 'Histories and Futures of the Digital Humanities', sorting: 1, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Methods', sorting: 2, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Practices', sorting: 3, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and the Disciplines', sorting: 4, edition: e2).first_or_create
Part.where(label: 'Digital Humanities and Its Critics', sorting: 5, edition: e2).first_or_create
Part.where(label: 'Forum: Text Analysis at Scale', sorting: 6, edition: e2).first_or_create
Part.where(label: 'Series Introduction and Editors’ Note', sorting: 7, edition: e2).first_or_create