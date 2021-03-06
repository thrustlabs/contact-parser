# contact-parser

A simple node module to parse street address strings (such as an email signature)
into component parts.  It's in use over at [Barnivore](http://barnivore.com/)
where we input a lot of street addresses.

At present it's optimized for United States and Canadian street addresses; other address formats will be
supported as we hammer the bugs out in production.

## Installation

`npm install contact-parser`

## Usage

Include the module

```javascript
var ContactParser = require('contact-parser');
```

Parse some address strings

```javascript
var parser = new ContactParser()
var result = parser.parse('Jason, 1 Yonge St')
console.log(result); // {name: 'Jason', email: '', province: '', country: '', address: '1 Yonge St', postal: '', website: '', phone: ''}
```

## Error handling

If passed an empty input (including null or undefined strings) the result will
be empty strings for all fields and a score of 0.

## Bugs

I'm sure there are several :) Help fix them by submitting an issue, or better yet, a tested pull request.


## License

[MIT](./MIT.LICENSE)
