FROM openjdk:latest
RUN curl -L boleyn.su/pgp | gpg --import
RUN yum install wget -y && yum clean all

ENV APPROOT=/boleyn.su/opt/boleyn.su/oj-judge/
RUN mkdir -p $APPROOT
WORKDIR $APPROOT

ENV VERSION=1.0.2
RUN wget https://repo1.maven.org/maven2/su/boleyn/oj/oj-judge/$VERSION/oj-judge-$VERSION-jar-with-dependencies.jar{,.asc}
RUN gpg --verify oj-judge-$VERSION-jar-with-dependencies.jar.asc

RUN useradd -r oj-judge
USER oj-judge:oj-judge
VOLUME /data

ENV RUNNER_HOST localhost
ENV RUNNER_PORT 1993
ENV DB_HOST localhost
ENV DB_NAME online_judge
# ENV DB_USER
# ENV DB_PASSWD
ENV DATA /data

CMD /usr/bin/bash -c '\
    java -jar $APPROOT/oj-judge-$VERSION-jar-with-dependencies.jar'
