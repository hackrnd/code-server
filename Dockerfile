
FROM codercom/code-server:latest

ARG git_url=https://github.com/avryhof/python-starter.git

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

RUN sudo npm install -g nodemon

RUN mkdir /home/coder/project
RUN git clone $git_url /home/coder/project

WORKDIR /home/coder/project