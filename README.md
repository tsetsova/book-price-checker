[![Build Status](https://travis-ci.org/tsetsova/book-price-checker.svg?branch=master)](https://travis-ci.org/tsetsova/book-price-checker/)
[![Code Climate](https://codeclimate.com/github/codeclimate/codeclimate/badges/gpa.svg)](https://codeclimate.com/github/tsetsova/book-price-checker)

# Book Price Checker

A simple ruby app that helps you track the prices of kindle books. 

## Installation

### Prerequisites

* ruby 2.5.1

You can use rvm to manage your ruby versions.  

To install the remaining dependencies run:

```
bundle install
```

### Use

To start the app run
```
ruby lib/main.rb -u 'book_url' -p 'desired_price'
```

To list currently watched titles run
```
ruby lib/main.rb -l
```

To find out any other currently supoorted options run
```
ruby lib/main.rb -h
```



