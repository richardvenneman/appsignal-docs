# AppSignal Documentation

This repository contains the source for the [AppSignal documentation
website][docs].

- [AppSignal.com website][appsignal]
- [Documentation][docs]
- [Support][contact]

## Usage

```sh
bundle install
bundle exec middleman
```

Open the browser at [localhost:4567](http://localhost:4567/) and click around.

## Deployment

```sh
bundle exec rake build_deploy
```

## Content

### Custom markdown tags

To render notices we've added a custom markdown tag. Use it like so:

```markdown
-> This is something you should know!
```

Which will render the following:

```html
<div class="notice">
  <p>This is something you should know.</p>
</div>
```

## Contributing

Thinking of contributing to our documentation? Awesome! 🚀

Please follow our [Contributing guide][contributing-guide] in our
documentation.

Also, we would be very happy to send you Stroopwaffles. Have look at everyone
we send a package to so far on our [Stroopwaffles page][waffles-page].

[appsignal]: https://appsignal.com
[contact]: mailto:support@appsignal.com
[waffles-page]: https://appsignal.com/waffles
[docs]: http://docs.appsignal.com
[contributing-guide]: http://docs.appsignal.com/contributing
