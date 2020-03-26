# Portunus

[![Maintainability](https://api.codeclimate.com/v1/badges/8370f4feb43195c73150/maintainability)](https://codeclimate.com/github/colinpetruno/portunus/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/8370f4feb43195c73150/test_coverage)](https://codeclimate.com/github/colinpetruno/portunus/test_coverage) [![Build Status](https://travis-ci.org/colinpetruno/portunus.svg?branch=master)](https://travis-ci.org/colinpetruno/portunus)

Portunus is an opininated, object-oriented encryption engine built for Ruby on Rails 
applications. It utilizes a KEK (Key Encryption Key) & DEK (Data
Encryption Key) scheme. 

KEK keys should be stored outside the application. Portunus provides a 
few default adaptors for working with common deployment setups. While this
is more secure than having unencrypted database data, the best use of 
Portunus would connect to and do the encryption / decryption of your keys
inside of an HSM. Portunus is easily extensible to accomplish this but it's
not included due to the extensive variety of possible deployments.

Lastly, Portnus has scripts included to do automatic rotation of these keys.
It's important to rotate both master keys and data encryption keys. Scripts
are included for both of these that can be scheduled via cron. 
&nbsp;  
## Background
Privacy and security need to be considered from the very start of building an
application. While web development has gotten more accessible, application
security has not. Portunus is intended to be a drop in utility that requires
just minutes of set up to ensure your app is using a DEK and KEK encryption 
key to protect your database from several types of attacks. If you want to 
go futher, it's easily extensible for your custom solution.  
&nbsp;  
## Installation

### Install the gem


    $ gem "portunus"


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install portunus

Run the generator. This will create the required Portunus tables.

    $ rails generate portunus:install
    $ rails db:migrate

Include the encryptable module on any of your models or add it to 
`ApplicationRecord` to ensure all your models have access to field encryption.

```ruby
include Portunus::Encryptable
```

### Set up your master keys

Portunus comes with two adaptors for your master keys, "credentials" and 
"environment". This should cover the most common deploy scenarios. Before
Portunus can function, enabled master keys need to be added. There is a 
generator to create the keys for you to then install in the proper 
location. 

    $ bundle exec rake portunus:generate_master_keys
    
If you are using the credentials adaptor (default), add the keys here. 
Make sure to generate keys for each environment.      
    
    $ bundle exec rails credentials:edit --environment=development

#### Spring / Postgres / OSX

When using this combination a bug may arise that prompts a weird error message:

    $ objc[4182]: +[__NSPlaceholderDictionary initialize] may have been in progress in another thread when fork() was called.

You can circumvent it by using the below command in High Sierra / Catalina. It 
might not work in Mojave but I believe this issue unrelated to Portunus.
Alternatively just don't use spring. 

    $ export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

### Additional devise notes

There is additional configuration required if you are using devise and 
desire to encrypt your email column. Devise will by default downcase email 
addresses. The downcasing performed by devise happens after the portunus 
encryption and result in broken encrypted values. This behaviour needs to 
be disabled from devise and you will need to handle the downcasing prior 
to encryption.  


&nbsp;  
## Basic Configuration

To enable encryption on a column, add the `encrypted_fields` method in the 
model and give it the fields you want to encrypt.

```ruby
class Member < ApplicationRecord
  encrypted_fields :email
end
```

### Database level defaults

Since the database does not have access to your encryption engine, default
values will break the encryption. You need to ensure defaults for encrypted
columns are set within your application logic.


### Type casting

In order to provide a simpler implementation in your app, Portunus has type 
casting support. The encrypted data must be stored as strings. To utilize 
Portunus with different types, you may specify the type on the field. 

```ruby
class User < ApplicationRecord
  encrypted_fields :email, :firstname, birthdate: { type: :date }
end
```

#### Supported types
- Boolean (:boolean)
- Date (:date)
- DateTime (:datetime)
- Float (:float)
- Integer (:integer)
- String (:string) (default)



### Hashing

Encrypted data cannot be searched. Portunus provides an automatic hash 
mechanism for encrypted data. The hashing happens prior to validation on the
model and will take your encrypted_field and put it into a column with a name
of `hashed_encrypted_field`. 

For instance, a migration for this may look like. 

```ruby
create_table :members do |t|
  t.string :hashed_email, null: false
  t.string :email, null: false
end
```

and the model:

```ruby
class Member < ApplicationRecord
  encrypted_fields :email
end
```

#### Portunus::Hasher
There is a class provided to perform the hashing that you can utilize to look up date.

```ruby
  User.find_by(email: ::Portunus::Hasher.for(params[:email])
```
&nbsp;  
## Advanced Setup

### Configuration block
Portunus can be easily customized using a configuration initializer.

```ruby
Portunus.configuration do |config|
  config.storage_adaptor = Portunus::StorageAdaptors::Credentials
  config.encrypter = Portunus::Encrypters::OpenSslAes
  config.max_key_duration = 1.month 
end
```

#### Options
- `storage_adaptor` - This is finds and looks up master keys.
- `encrypter` - This is responsible for setting the encrypter that encrypts
  decrypts the data. 
- `max_key_duration` - Timeframe for how old you want to allow keys to exist for. 
  Ideally your keys are constantly being rotated. Used in key rotation tasks.

&nbsp;   
## Storage adaptors

Storage adaptors provide the interface to determine which master key to decrypt
a data key. Portunus comes with two adaptors to access master keys out of the box.

- **Portunus::StorageAdaptors::Environment**
- **Portunus::StorageAdaptors::Credentials**

We need to keep track of the following items:

- **Key name** - This is what is stored on the data encryption key table to find the
  master key
- **Enabled** - Whether the key is enabled for new data keys. Note: If you disable a 
  key, that just stops future keys from generating. Until all the keys are rotated,
  do not remove the key. 
- **Created date** - When the key was created to help track rotation duration

The master key id is stored on the data key table. These adaptors work like hash
maps. The key id is passed and a value is returned. The value for both default
adaptors is the master key. However if you were writing for an environment where keys
are stored inside an HSM the value could be the key id in the HSM. The encrypter
would then take that key id and interface with the HSM. 

Adaptors are easily registered in the config so you can take an existing one 
and customize to your requirements. 

### EnvironmentAdaptor
Store and manage keys through any environment. Great for deployments like 
Heroku. The environment adaptor needs multiple keys per master key to track
the key value, date created and enabled.  


### Credentials adaptor (default)
This gets your master keys from your rails credential files. An example 
structure is:

```yaml
portunus:
  f9e59a8c17c5f430f17745a522ebc2b7:
    key: 93a05a5ce18afb85162a34d552c953b3
    enabled: true
    created_at: "2020-03-13T12:11:11+01:00"
  140f33e69f0647cbc14b64605f002ff6:
    key: d2c2aa9b7aeff75513ca24efcd8b8dd3
    enabled: true
    created_at: "2020-03-13T12:11:11+01:00"
```
&nbsp;
## Key rotation
Portunus provides key rotation scripts to rotate DEKs, KEKs, and both at 
once. The DEK rotation script will rotate keys every six months. If provided
a force option as an environment variable it will rotate all the keys. The 
KEK rotation will rotate all master keys. This will probably take a long time
in many apps so therefore you can rotate the master keys invidually by 
providing the key name. 


    $ bundle exec rake portunus:rotate_deks
    $ FORCE=true bundle exec rake portunus:rotate_deks
    $ bundle exec rake portunus:rotate_keks
    $ KEY_NAME=<keyname> bundle exec rake portunus:rotate_deks
   
&nbsp;  
## Tips
- Security is about applying layers. Using Portunus with the default 
configuration helps protects against specific types of attacks. However, in the 
event your complete environment is compromised there is not much that can
be done. 
- Providing seperation of concerns within your organization can help if you
need the data to survive even if someone gets direct server access. Every 
aspect of Portunus is easily configured to ensure this is possible for you.
- When deciding how many master keys to use, keep the amount of data in mind.
  Each key is responsible for encrypting a certain number of DEKs. The lower
  this is kept the easier it will be to rotate. 
- Schedule rotation often. The dek rotator can be run every day or on even
  smaller intervals. 




&nbsp;  
## Improvements

Some items I'd like to see added:

- Migration support from an unencrypted to encrypted column
- Google Cloud HSM Encrypter
- Improve key rotations
- Research better devise solution.
- Different encrypters or key sources for different data rows 
- Dashboard to show key usage and which keys can be removed
- Automatic master key introduction and rotation

&nbsp;  
## Development

After checking out the repo, run `bundle install to install dependencies. 

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then 
run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file 
to [rubygems.org](https://rubygems.org).
&nbsp;  
## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/colinpetruno/portunus. This project is intended to be a 
safe, welcoming space for collaboration, and contributors are expected to 
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of 
conduct.
&nbsp;  
## License

The gem is available as open source under the terms of 
the [MIT License](https://opensource.org/licenses/MIT).
&nbsp;  
## Code of Conduct

Everyone interacting in the Portunus project’s codebases, issue trackers, 
chat rooms and mailing lists is expected to follow 
the [code of conduct](https://github.com/[USERNAME]/portunus/blob/master/CODE_OF_CONDUCT.md).
