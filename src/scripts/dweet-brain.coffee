# Description:
#   Dweet.io Brain
#
# Dependencies
#   "node-dweetio": "0.0.11"
#
# Configuration
#   THING the name of the thing
#
# Commands:
#   None
#
# Authors:
#   wdalmut

Util = require "util"

dweetClient = require "node-dweetio"

module.exports = (robot) ->
  thing = process.env.HUBOT_THING
  dweetio = new dweetClient()

  robot.brain.setAutoSave false

  getData = ->
    dweetio.get_latest_dweet_for thing, (err, dweet) ->
      if !err
        robot.logger.info "Data for #{thing} brain retrieved from Dweet.io"
        robot.brain.mergeData dweet[0].content
      else
        robot.logger.info "Initializing new data for #{thing} brain"
        robot.brain.mergeData {}

      robot.brain.setAutoSave true
  getData()


  robot.brain.on 'save', (data={}) ->
    dweetio.dweet_for thing, data, (err, dweet) ->
      if err
        throw err

