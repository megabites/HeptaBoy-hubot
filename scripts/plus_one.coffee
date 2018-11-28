# Thanking user by giving +1
#
# Commands:
# hubot <@colega>: +1, ou valeu, ou :+1: por <ajuda> - Para dar mais um ponto de ajuda para um colega ! 
# hubot Quem me deve uma - Ver quantas pessoas eu ajudei 
# hubot (show ranking|ranking) - Ver a pontuação geral

module.exports = (robot) ->
  robot.brain.data.achievements ||= {}

  #robot.hear /[^@heptaboy](.*): *(\+1|valeu|\:\+1\:|\:thumbsup\:) por(.*)$/i, (msg) ->
  robot.hear /^(.*):\s*(\+1|valeu|\:\+1\:|\:thumbsup\:) por(.*)$/i, (msg) ->
    #receiver = msg.match[1].replace('@','').trim()
    #console.log(msg)
    receiver = msg.match[1].replace('@','')
    console.log(receiver)
    console.log ("thanking:" + msg.message.user.name)
    console.log ("receiver:" + receiver)
    console.log ("reason:" + msg.match[3])
    thanking = msg.message.user.name
    reason   = msg.match[3]

    if receiver == thanking
      msg.send "Ta de sacanagem, né!"

    if not (reason?.length) 
      msg.send "#{thanking}: você, poderia me dizer o motivo? Feedback positivos são sempre bons :hugging_face:"

    if reason == ' '
      msg.send "#{thanking}: você, poderia me dizer o motivo? Feedback positivos são sempre bons :hugging_face:"

    if receiver != thanking and reason?.length
      robot.brain.data.achievements[receiver] ||= []
      event = {reason: reason, given_by: thanking}
      robot.brain.data.achievements[receiver].push event
      msg.send "#{event.given_by} disse obrigado para #{receiver} por #{event.reason}"

  robot.respond /Quem me deve uma ??/i, (msg) ->
    console.log(msg.message.user.name)
    user = msg.message.user.name
    console.log("User:" + user)
    console.log (robot.brain.data.achievements[user])
    
    if not (robot.brain.data.achievements[user])
      msg.send "Ninguem seu inutil !!"
    else
      response = "#{user}, Você recebeu #{robot.brain.data.achievements[user].length} pontos de:\n"
      for achievement in robot.brain.data.achievements[user]
        response += "```#{achievement.given_by} por #{achievement.reason}```\n"
      msg.send response

  robot.respond /ranking/i, (msg) ->
    ranking = []

    for person, achievements of robot.brain.data.achievements
      ranking.push {name: person, points: achievements.length}

    sortedRanking = ranking.sort (a, b) ->
      b.points - a.points

    message = "Ranking\n"

    position = 0
    for user in sortedRanking
      position += 1
      message += "#{position}. #{user.name} - #{user.points}\n"

    msg.send message
