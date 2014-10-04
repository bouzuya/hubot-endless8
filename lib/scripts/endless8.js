// Description
//   A Hubot script that counts your messages like the endless 8
//
// Configuration:
//   None
//
// Commands:
//   hubot 何回目だ？ - counts your messages like the endless 8
//
// Author:
//   bouzuya <m@bouzuya.net>
//
module.exports = function(robot) {
  return robot.respond(/.*(?:なんかい|何回)(?:め|目)?だ？?$/i, function(res) {
    var count, _ref;
    count = (_ref = res.robot.brain.get('endless8')) != null ? _ref : 1;
    res.robot.brain.set('endless8', count + 1);
    res.robot.brain.save();
    return res.send("" + count + "回目");
  });
};
