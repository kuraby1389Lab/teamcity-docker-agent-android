FROM jetbrains/teamcity-agent:10.0.5

MAINTAINER Martin Šindelář & Lukáš Nevařil

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get install -y mc
RUN apt-get install -y gradle

ENV GRADLE_HOME=/usr/bin/gradle

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
