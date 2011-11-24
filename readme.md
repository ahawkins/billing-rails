# Billing for Rails

[![Build Status](https://secure.travis-ci.org/[Adman65]/[billing-rails].png)](http://travis-ci.org/[Adman65]/[billing-rails])

This project wraps up the [Billing](https://github.com/adman65/billing)
into a nice package for use in Rails controllers. 

Its primary purpose is to **ensure that credit & debits are only applied
if the response returns successfully.** This model works if multiple
charges or debits may be applied during one request. If some code
somewhere else raise an exception, your accounts will be reset back to their
initial state. For example, you debit the account for adding a user.
However the sign up mailer raises an error. Without proper handling the
account will have unproper debit. This handles this case.

billing-rails also defines a `current_tab` method in your
`ApplicationController`. However, you will have to define method
yourself to get rid of the error message :D

## What It Does

1. Undoes credits & debits if the response does not return successfully
   (Reponse code >= 400)
2. Automatically capture Billing::NotEnoughFund errors and return a 402
   (Payment Required) status code
3. Treat ActionController::Base as a Billing::Tab

## Installing

```ruby
# in your Gemfile

gem 'billing-rails'
```

## Using

```
# Using a before filter to check to see if the request
# can even happen. 
class BillableResourceController < ApplicationController
  before_filter :check_balance, :only => :create

  def create
    # do stuff
  end

  private
  def check_balanace
    raise Billing::NotEnoughFunds unless debit_authorized?(:billable_resource)
  end
end

# Using multiple debits
class BillableResourceController < ApplicationController

  # Debits will be undone if save throws an 
  # error (or any other peice of code does)
  def create
    debit :billable_resource
    if should_do_more_stuff?
      debit :additional_reource
    end

    record.save!
  end
end
```

# License

This project rocks and uses MIT-LICENSE.
