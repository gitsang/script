docker run \
    --name confluence \
    -p 8090:8090 \
    -p 8091:8091 \
    -v /data/confluence/:/var/atlassian/application-data/confluence \
    -d atlassian/confluence-server
