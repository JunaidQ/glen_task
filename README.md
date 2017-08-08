*Developer*

This assumes Ubuntu Linux.

Some basic steps:

- Install RVM

Then do the following:

```
rvm install 2.3.0
git clone git@github.com:JunaidQ/glen_task.git
cd glen_task
gem install bundler
bundle install
```

To enter the Shopiy store in yml file:

```
cp config/local_env.example.yml config/local_env.yml
```

To run the local development server:

```
rails s
```
Browse to http://localhost:3000
