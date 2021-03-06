# for JavaScript
mkdir -p /data/wechaty
docker rm -f wechaty

docker run -d \
    --name wechaty \
    -v /data/wechaty:/bot \
    wechaty/wechaty \
    bot.js
