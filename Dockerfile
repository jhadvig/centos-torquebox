# centos-torquebox

FROM       centos
MAINTAINER Jakub Hadvig <jhadvig@redhat.com>

RUN mkdir -p /opt/torquebox && useradd torquebox -c"Torquebox system user" -M -ptorquebox

RUN yum update --assumeyes && \
	yum install --assumeyes java-1.7.0-openjdk.x86_64 tar iproute wget unzip sqlite-devel libsqlite3x-devel nodejs010-nodejs zlib-devel libxslt-devel libxml2-devel openssl-devel && \
	yum clean all && \
	cd /opt/ && \
	wget http://torquebox.org/release/org/torquebox/torquebox-dist/3.0.0/torquebox-dist-3.0.0-bin.zip && unzip torquebox-dist-3.0.0-bin.zip -d /opt/torquebox

ENV TORQUEBOX_HOME /opt/torquebox/torquebox-3.0.0
ENV JBOSS_HOME $TORQUEBOX_HOME/jboss
ENV JRUBY_HOME $TORQUEBOX_HOME/jruby
ENV PATH $JRUBY_HOME/bin:/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.55.x86_64/jre/bin:$PATH

RUN mkdir -p /opt/ruby/{gems,run,src,bin}

ENV APP_ROOT .
ENV HOME /opt/ruby

ADD start_torquebox.sh /opt/torquebox/start_torquebox.sh
RUN chown -R torquebox:torquebox /opt/torquebox && chmod u+x /opt/torquebox/start_torquebox.sh

ADD ./bin /opt/ruby/bin/

RUN cp -f /opt/ruby/bin/prepare /usr/bin/prepare && \
    cp -f /opt/ruby/bin/run /usr/bin/run

EXPOSE 9999 9990 9443 8009 8080 8443 45700 7600 57600 55200 45688 54200 5445 9876 5455 23364 4447 4712 4713 8675 8676

CMD ["/opt/ruby/bin/start"]
