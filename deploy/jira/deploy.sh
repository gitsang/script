mkdir -p /data/jira
docker rm -f jira
docker run \
    --name jira \
    -p 8080:8080 \
    -v /data/jira:/var/atlassian/application-data/jira \
    -d atlassian/jira-software
