# Description
#   A Hubot script that counts your messages like the endless 8
#
# Configuration:
#   None
#
# Commands:
#   hubot 何回目だ？ - counts your messages like the endless 8
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /.*(?:なんかい|何回)(?:め|目)?だ？?$/i, (res) ->
    count = res.robot.brain.get('endless8') ? 1
    res.robot.brain.set 'endless8', count + 1
    res.robot.brain.save()
    res.send "#{count}回目"
