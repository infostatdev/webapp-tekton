#Grab the latest alpine image
FROM debian:bookworm

# Install python and pip
RUN apt-get update
RUN apt-get install -y python3 python3-pip sudo 
ADD ./webapp/requirements.txt   /tmp/requirements.txt

# Install dependencies
RUN apt-get update && apt-get upgrade
RUN apt-get install -y python3.11-venv
RUN python3 -m venv ./venv
RUN . venv/bin/activate
RUN venv/bin/pip install -r /tmp/requirements.txt
CMD deactivate
RUN apt-get update

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose is NOT supported by Heroku
EXPOSE 5000 		

# Run the image as a non-root user
RUN useradd -m -s /bin/bash Guire && echo "Guire:infostat7" 
USER Guire

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT wsgi 

