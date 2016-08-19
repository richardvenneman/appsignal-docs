# AppSignal Documentation

Feel free to improve the documentation by creating a branch and/or Pull-Request.

## Usage

```sh
bundle install
bundle exec middleman
```

## Deploy

```sh
bundle exec rake build_deploy
```

## Custom markdown tags

To render notices we've added a custom markdown tag, you can use it like so:

```markdown
-> This is somehting you should know
```

It will render:

```html
<div class="notice">
  <p>This is something you should know.</p>
</div>
```
