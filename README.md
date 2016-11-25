flakes
======

[![Gem Version](https://badge.fury.io/rb/flakes.svg)](https://badge.fury.io/rb/flakes)

### Description

Flakes is an extension of [Active Model](https://github.com/rails/rails/tree/master/activemodel) and [Active Job](https://github.com/rails/rails/tree/master/activejob) to provide service object functionality.

This started as an experiment to write a framework for hexagonal architecture but turned into a collection of service object functions that I am reusing for several projects.

The idea is to break down the business logic into basic operations that can be composed to provide complex functionality but can be easily unit tested.

### Getting started

To install:

    gem install flakes

If you use a Gemfile:

```ruby
  gem "flakes"
```

### Features
  * Flake takes `failure` and `success` procs
  * `#with_valid_params`
      * runs validations and causes flake to fail if invalid
      * wraps code into ActiveRecord transaction
  * Flake fails if an object with errors is passed to `#success`
  * Calling `execute_later` runs Flake in background
  * Active Model validations

### Example
Simple example for creating posts and adding tags to them during creation and afterwards.

```ruby
  class PostsController < ApplicationController
    def create
      flake = PostCreating.new(post_params)
      flake.on_success { |post| @post = PostPresenter.new(post) }
      flake.on_failure { |errors| json_error(errors) }
      flake.execute
    end

    def add_tags
      flake = PostTagAdding.new(tag_params)
      flake.on_success { |post| @post = PostPresenter.new(post) }
      flake.on_failure { |errors| json_error(errors) }
      flake.execute
    end

    private

    post_params
      params.require(:post).permit(:text, :tags).merge(user: current_user)
    end

    tag_params
      params.permit(:tags).megre(post_id: params[:id])
    end
  end
```

```ruby
  class PostCreating < Flake
    attr_accessor :text, :tags, :user

    validates :text, :tags, :user, presence: true

    def execute
      with_valid_params do
        create_post
        add_tags

        success(post)
      end
    end

    private

    attr_reader :post

    def create_post
      @post = Post.create!(user: user, text: text)
    end

    def add_tags
      @post = PostTagAdding.execute(post: post, tags: tags)
    end
  end
```

```ruby
  class PostTagAdding < Flake
    attr_accessor :post_id, :post, :tags

    validates :post, :tags, presence: true

    def execute
      with_valid_params do
        add_tags

        success(post)
      end
    end

    private

    def add_tags
      post.tags << tag_objects
    end

    def tag_objects
      tag_names.map do { |name| Tag.find_or_create_by(name: name) }
    end

    def tag_names
      tags.split(",")
    end

    def post
      @post ||= Post.find_by(id: post_id)
    end
  end
```

### Contribute
  If you are using flakes and missing something, feel free to open a PR.
  Currently the functionality is only tested through my projects, but I will add tests and better documentation in the near future.
