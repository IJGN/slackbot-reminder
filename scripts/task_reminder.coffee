# Description:
#   simple task reminder.
#
# Commands:
#   hubot now  - 今やっているタスクを記録します
#   hubot note - 連絡事項を記録します
#   hubot today - now, note の内容をレポート形式でまとめます

# 時刻を受け取ってYYYY-mm-dd形式で返す
toYmdDate = (date) ->
    Y = date.getFullYear()
    m = ('0' + (date.getMonth() + 1)).slice(-2)
    d = ('0' + date.getDate()).slice(-2)
    return "#{Y}-#{m}-#{d}"

# 時刻を受け取ってhh:mm形式で返す
tohhmmTime = (date) ->
    hh = ('0' + date.getHours()).slice(-2)
    mm = ('0' + date.getMinutes()).slice(-2)
    return "#{hh}:#{mm}"

module.exports = (robot) ->
  # keyを設定
  keyTask = "taskTracker"
  keyNote = "noteTracker"

  robot.respond /now (.*)/i, (msg) ->
    # 発言から内容を取得。date,text,userの3つ
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    tasks = robot.brain.get(keyTask) ? []
    task = {
      user: user,
      date: toYmdDate(date),
      time: tohhmmTime(date),
      task: text
    }
    tasks.push task
    robot.brain.set keyTask, tasks
    msg.reply "task save! #{tohhmmTime(date)} #{text}"
    msg.finish()

  robot.respond /note (.*)/i, (msg) ->
    # 発言から内容を取得。date,text,userの3つ
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    tasks = robot.brain.get(keyNote) ? []
    task = {
      user: user,
      date: toYmdDate(date),
      time: tohhmmTime(date),
      task: text
    }
    tasks.push task
    robot.brain.set keyNote, tasks
    msg.reply "note save! #{tohhmmTime(date)} #{text}"
    msg.finish()

  robot.respond /today$/, (msg) ->
    date = new Date
    user = msg.message.user.name
    tasks = robot.brain.get(keyTask) ? []

    # Tasks
    message = tasks.filter (task) ->
      task.date == toYmdDate(date)
    .filter (task) ->
      task.user == user
    .map (task) ->
      "\t#{task.time} #{task.task}"
    .join '\n'

    # Notes
    notes = robot.brain.get(keyNote) ? []
    noteMessage = notes.filter (note) ->
      note.date == toYmdDate(date)
    .filter (note) ->
      note.user == user
    .map (note) ->
      "\t#{note.time} #{note.task}"
    .join '\n'

    # Reminder
    answer = toYmdDate(date)+'\n'
    answer = answer + '*Tasks*\n'
    answer = answer + "#{message}\n\n"
    answer = answer + '*Notes*\n'
    answer = answer + "#{noteMessage}\n"
    msg.reply answer
    msg.finish()
