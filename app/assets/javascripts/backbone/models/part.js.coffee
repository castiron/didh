class Didh.Models.Part extends Backbone.Model
  paramRoot: 'part'

  defaults:
    label: null

class Didh.Collections.PartsCollection extends Backbone.Collection
  model: Didh.Models.Part
  url: '/parts'
