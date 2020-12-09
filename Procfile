// From Heroku app resources
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV 
// Limits to 2 jobs concurrently (-c 2) because of Heroku and Redis client limits
worker: bundle exec sidekiq -c 2
