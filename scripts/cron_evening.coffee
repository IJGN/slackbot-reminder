cronJob = require('cron').CronJob
time = require('time')

module.exports = (robot) ->

    channel = process.env.HUBOT_SLACK_MAIN_CHANNEL

    cronjob = new cronJob(
      cronTime: "0 0 19 * * 1-5"
      start:    true                # すぐにcronのjobを実行するかどうか
      timeZone: "Asia/Tokyo"        # タイムゾーン
      onTick: ->                    # 実行処理
        now = new time.Date()
        robot.send {room: channel }, "お疲れ様です :beer: "+now.getHours()+"時"+now.getMinutes()+"分になりました！"
    )
