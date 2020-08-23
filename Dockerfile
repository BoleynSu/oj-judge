FROM maven as build
RUN useradd builder
WORKDIR /build
RUN chown builder:builder /build
USER builder
COPY --chown=builder ./ ./

RUN mvn install -Dgpg.skip -f external/oj-core/pom.xml
RUN mvn package
RUN mkdir -p out
RUN mvn help:evaluate -q -Dexpression=project.version -DforceStdout > out/version
RUN mv target/oj-judge-$(cat out/version)-jar-with-dependencies.jar out/oj-judge.jar

FROM openjdk
COPY --from=build /build/out /oj-judge

RUN useradd -r oj-judge
USER oj-judge
VOLUME /data

ENV RUNNER_HOST localhost
ENV RUNNER_PORT 1993
ENV DB_HOST localhost
ENV DB_NAME online_judge
# ENV DB_USER
# ENV DB_PASSWD
ENV DATA /data

CMD java -jar /oj-judge/oj-judge.jar
