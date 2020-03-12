# Portunus

[![Maintainability](https://api.codeclimate.com/v1/badges/8370f4feb43195c73150/maintainability)](https://codeclimate.com/github/colinpetruno/portunus/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/8370f4feb43195c73150/test_coverage)](https://codeclimate.com/github/colinpetruno/portunus/test_coverage) [![Build Status](https://travis-ci.org/colinpetruno/portunus.svg?branch=master)](https://travis-ci.org/colinpetruno/portunus)

Portunus is an opininated encryption engine built for Ruby on Rails 
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

## Installation

You will need to add Portunus and the latest commit of the AES gem. This is
due to fixing an openssl deprecation that has not yet been added as a new
release in Ruby Gems. 

```ruby
gem "portunus"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install portunus

Run the generator. This will create the required Portunus tables.
```
rails generate portunus:install
rails db:migrate
```

Include the encryptable module on any of your models or add it to 
`ApplicationRecord` to ensure all your models have access to field encryption.
```ruby
include Portunus::Encryptable
```

### Devise notes

If you are using devise it will by default downcase email addresses. If this
field is encrypted the downcasing performed by devise happens after the 
portunus encryption. Thus it will make the value unencrypted. 

For now you can turn this off in the devise initializer by updating 
`case_insensitive_keys`. You will then need to manage yourself prior to setting
the email. There could be a similar config option added to portunus at some
point to help assist and make it easier for developers using the gem.



#### Basic Configuration

To enable encryption on a column, add the `encrypted_fields` method in the 
model and give it the fields you want to encrypt.
```ruby
class Member < ApplicationRecord
  encrypted_fields :email
end
```

#### Hashing

Encrypted data cannot be searched. Portunus provides an automatic hash 
mechanism for encrypted data. The hashing happens prior to validation on the
model and will take your encrypted_field and put it into a column with a name
of `hashed_encrypted_field`. 

For instance, a migration for this may look like. 
```
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


### Adaptors

Portunus comes with two adaptors to access keys out of the box.
- Portunus::MasterKeys::EnvironmentAdapter
- Portunus::MasterKeys::CredentialsAdapter

If you have your key encryption keys stored in a custom HSM or other solution, 
you can write your own adaptor and register it to portunus to retrieve your 
master keys (or send the data encryption key to be encrypted)

### EnvironmentAdaptor
This is for getting keys from the environment. It is important to prefix the 
key with PORTUNUS, ie PORTUNUS_MASTER_KEY_1. 

By default, it will assume the key is enabled. You can configure which keys
are enabled in your configuration or via env var.

PORTUNUS_MASTER_KEY_1_ENABLED=false

TODO: Rotation script should find disabled keys and force rotation to a new
key 

### Credentials adaptor
This gets your master keys from your rails credential files. It does this by
looking for 

```
Rails.application.credentials.portunus[:master_key_1]
```


### Tips

### Improvements

Some items I'd like to see added:
- Migration support from an unencrypted to encrypted column
- Google Cloud HSM Encrypter
- Improve key rotations
- Research better devise solution. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can 
also run `bin/console` for an interactive prompt that will allow you to 
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then 
run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file 
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/colinpetruno/portunus. This project is intended to be a 
safe, welcoming space for collaboration, and contributors are expected to 
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of 
conduct.

## License

The gem is available as open source under the terms of 
the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Portunus project’s codebases, issue trackers, 
chat rooms and mailing lists is expected to follow 
the [code of conduct](https://github.com/[USERNAME]/portunus/blob/master/CODE_OF_CONDUCT.md).
