FROM registry.gitlab.com/kaashyapan/growel/alpine-elixir-phx-aws:latest as build 

ENV MIX_ENV=prod PORT=4001

COPY . .
RUN mix deps.get && mix deps.compile

WORKDIR /opt/app/
RUN mix distillery.release

#Extract Release archive to /rel for copying in next stage
RUN APP_NAME="apigateway" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#================
#Deployment Stage
#================
FROM bitwalker/alpine-erlang:21.3.8

#Set environment variables and expose port
EXPOSE 4001

ENV REPLACE_OS_VARS=true \
    PORT=4001 \
    MIX_ENV=prod

RUN apk update
RUN apk add ca-certificates && update-ca-certificates
# Change TimeZone
RUN apk add --update tzdata
ENV TZ=Asia/Calcutta

RUN rm -rf /var/cache/apk/*

ENV AWS_ACCESS_KEY_ID="xxx"
ENV AWS_SECRET_ACCESS_KEY="xxx"
ENV AWS_DEFAULT_REGION="us-east-1"

# Expose port 4001 for phoenix api
EXPOSE 4001

#Copy and extract .tar.gz Release file from the previous stage
COPY --from=build /export/ .

#Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/apigateway"]
CMD ["foreground"]
