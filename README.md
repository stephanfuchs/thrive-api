# Getting started
1. `./scripts/init_project.sh` to get the basic setup running
2. `./bin/rails_start` should always run and will provide a server on port 8086
3. If you want to run rails commands in the docker container run `./bin/rails_docker your-command`
  1. Run rails console via `./bin/rails_docker c`
4. For sidekiq run `./bin/rails_sidekiq`

# Other scripts
- `./scripts/toggle_cache.sh` will allow you to toggle caching. By default rails will not cache.
