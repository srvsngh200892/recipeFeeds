# Code

### Important point about this app

1) This application fetches recipes of marley spoon using contentful API's

2) We have added the pagination so that we dont load all the data. It's fetches 4 record per page

3) We have used adapter design pattern because this give fexlibility to integrate more sources other then contentful, by just adding one more adapter.

4) Used and refere contentful ruby gem (https://github.com/contentful/contentful.rb)

### Programing Langauage & Framework used

1) Ruby 2.6.3 and Rails 6.0.2

### File structure (Where to find code)
```
-- .recipeFeeds
    |-- app
        |--controllers
           |--receipes_contoller.rb 
      
        |--services
           |--recipes
              |--client_adapters (contains different client logic)
                |--contentful.rb (contains logic of fetching rescipe according to contentful API documentation)
              |--clinet.rb(contain the logic of calling client based on setting. Currently as we have only one client and if no client mention we use defalut one
              |--attributes.rb ( contains the attributes of recipes)


```
### How to run application
* Docker way
```
1) git clone repositories
2) Go inside dir recipeFeeds
3) docker-compose build
4) docker-compose up
5) hit localhost:8080
6) enjoy viewing recipes

```

* Normal way
```
1) Install ruby and rails with metion version
2) git clone repositories
3) cd recipeFeeds
4) bundle install
5) rails s
6) hit localhost:3000
7) enjoy finding most delicious recipes
```

### Docker Containers
```
1) We have 1 docker containers
   1) For API
      CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
      72aceb3622fa        recipefeeds_website   "/bin/sh -c 'RAILS_E…"   30 minutes ago      Up 30 minutes       0.0.0.0:8080->8080/tcp   recipefeeds_website_1

```
