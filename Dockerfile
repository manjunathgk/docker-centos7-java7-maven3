FROM centos:7
MAINTAINER Manjunath Gouda, gk_manjunath@yahoo.com

ENV JAVA_VERSION 7u80
ENV BUILD_VERSION b15

# Upgrading system
RUN yum -y upgrade && \
    curl -L -k  -H "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" > /tmp/jdk-7-linux-x64.rpm && \
    yum -y install /tmp/jdk-7-linux-x64.rpm && \
    yum clean all && rm -rf /tmp/jdk-7-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000 && \
    alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 && \
    alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest

USER root 

RUN yum -y install wget

WORKDIR /tmp/
RUN cd /tmp/

RUN wget http://mirrors.ibiblio.org/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz 
RUN tar xzf apache-maven-3.3.9-bin.tar.gz -C /usr/local
RUN cd /usr/local
RUN ln -s apache-maven-3.3.9 maven

ENV M2_HOME /usr/local/apache-maven-3.3.9
ENV PATH ${M2_HOME}/bin:${PATH}
RUN alternatives --install /usr/local/apache-maven-3.3.9/bin/mvn mvn /usr/local/maven/bin/mvn 1    

RUN rm -rf apache-maven-3.3.9-bin.tar.gz 
RUN mkdir -p /opt/ 

RUN yum -y install git

WORKDIR /tmp/

RUN git config --global http.postBuffer 524288000

RUN git init

RUN java -version
RUN mvn -version
RUN git --version
