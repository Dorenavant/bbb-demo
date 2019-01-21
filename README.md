# README

## SETUP
You must have NodeJS, PostgreSQL, Ruby, and Rails installed for this to work.

### Clone the repository
`git clone https://github.com/Dorenavant/bbb-demo.git && cd bbb-demo`
### Bundle install
`gem install bundler && bundle install`
### PostgreSQL stuff
You must setup a database role on your local PostgreSQL and set the proper credentials in the app.
### Install binstubs
`rails app:update:bin`
### Puma setup
Create the folders for puma to log, set PIDs, and open the socket.
`mkdir -p shared/log shared/pids shared/sockets`
### Run server
`rails s`
