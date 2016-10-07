# H2MS
## H4OME Holonic Map Server

For now this is the API backend to the H4OME native client
that simulates both IPFS and Ethereum functions within H4OME,
until stable light/mobile client versions of these technologies
are available.

Later on it will act as a node within the decentralized object space
that H4OME is to cache holons and implement higher-level functions
such as synergy engines and AIs.

### API spec

__/api/v1__:

* __/session:__  [POST: ```email, password```]
* __/users:__ 
 	[POST: ```email, username, password, password_confirmation```]
* __/holons:__
   [POST: ```data```]
* __/holons/{hash}:__
    [GET]
* __/namespaces/{homepath}:__
    [GET]
	[PUT: ```path, hash```]	

(see [doc](file://../doc/holonic_map_server.html))


### Dependencies

You need to have [Ruby on Rails >=5.0](http://rubyonrails.org/) installed (which needs [Ruby >=2.2](https://github.com/rbenv/rbenv)).

After installing Ruby install Rails and Bundler with

```
gem install rails
gem install bundler
```

and then whithin this directory do

```
bundle
```

to install all needed gems.


### Run development server

Within this directory do

```
bundle exec rails s
```


