### Project setup:
Navigate the project folder and run

```
bundle install
```
Initialize project database settings:

```
bundle exec rails db:setup
```

### Run server

To run server: 

```
bundle exec rails s
```

### Run sidekiq

Sidekiq is used for cronjob
```
bundle exec sidekiq -C config/sidekiq.yml
```
