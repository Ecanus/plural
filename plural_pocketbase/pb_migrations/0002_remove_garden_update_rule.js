/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("hfm1u474v8aexau")

  // update collection data
  unmarshal({
    "updateRule": ""
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("hfm1u474v8aexau")

  // update collection data
  unmarshal({
    "updateRule": "creator.id = @request.auth.id"
  }, collection)

  return app.save(collection)
})
