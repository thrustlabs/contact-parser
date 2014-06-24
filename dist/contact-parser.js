
/*
ContactParser: an address parser class

Version 1.0

https://github.com/thrustlabs/contact-parser

Copyright 2014 Jason Doucette, Thrust Labs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
var ContactParser,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ContactParser = (function() {
  var ContactParserResult, americanStates, canadianProvinces;

  function ContactParser() {}

  ContactParserResult = (function() {
    function ContactParserResult() {
      this.name = '';
      this.email = '';
      this.province = '';
      this.country = '';
      this.address = '';
      this.postal = '';
      this.website = '';
      this.phone = '';
    }

    return ContactParserResult;

  })();

  canadianProvinces = {
    'british columbia': 'BC',
    'bc': 'BC',
    'alberta': 'AB',
    'ab': 'AB',
    'saskatchewan': 'sk',
    'sk': 'SK',
    'manitoba': 'MB',
    'mb': 'MB',
    'ontario': 'ON',
    'on': 'ON',
    'quebec': 'QC',
    'qc': 'QC',
    'newfoundland': 'NL',
    'newfoundland and labrador': 'NL',
    'newfoundland and labrador': 'NL',
    'labrador': 'NL',
    'nl': 'NL',
    'new brunswick': 'NB',
    'nb': 'NB',
    'prince edward island': 'PE',
    'PEI': 'PE',
    'pe': 'PE',
    'nova scotia': 'NS',
    'ns': 'NS',
    'yukon territories': 'YT',
    'yukon': 'YT',
    'yt': 'YT',
    'northwest territories': 'NT',
    'nt': 'NT',
    'nunavut': 'NU',
    'nu': 'NU'
  };

  americanStates = {
    'alabama': 'AL',
    'al': 'AL',
    'alaska': 'AK',
    'ak': 'AK',
    'american samoa': 'AS',
    'as': 'AS',
    'arizona': 'AZ',
    'az': 'AZ',
    'arkansas': 'AR',
    'ar': 'AR',
    'california': 'CA',
    'ca': 'CA',
    'colorado': 'CO',
    'co': 'CO',
    'connecticut': 'CT',
    'ct': 'CT',
    'delaware': 'DE',
    'de': 'DE',
    'district of columbia': 'DC',
    'd.c.': 'DC',
    'dc': 'DC',
    'federated states of micronesia': 'FM',
    'fm': 'FM',
    'florida': 'FL',
    'fl': 'FL',
    'georgia': 'GA',
    'ga': 'GA',
    'guam': 'GU',
    'gu': 'GU',
    'hawaii': 'HI',
    'hi': 'HI',
    'idaho': 'ID',
    'id': 'ID',
    'illinois': 'IL',
    'il': 'IL',
    'indiana': 'IN',
    'in': 'IN',
    'iowa': 'IA',
    'ia': 'IA',
    'kansas': 'KS',
    'ks': 'KS',
    'kentucky': 'KY',
    'ky': 'KY',
    'louisiana': 'LA',
    'la': 'LA',
    'maine': 'ME',
    'me': 'ME',
    'marshall islands': 'MH',
    'mh': 'MH',
    'maryland': 'MD',
    'md': 'MD',
    'massachusetts': 'MA',
    'ma': 'MA',
    'michigan': 'MI',
    'mi': 'MI',
    'minnesota': 'MN',
    'mn': 'MN',
    'mississippi': 'MS',
    'ms': 'MS',
    'missouri': 'MO',
    'mo': 'MO',
    'montana': 'MT',
    'mt': 'MT',
    'nebraska': 'NE',
    'ne': 'NE',
    'nevada': 'NV',
    'nv': 'NV',
    'new hampshire': 'NH',
    'nh': 'NH',
    'new jersey': 'NJ',
    'nj': 'NJ',
    'new mexico': 'NM',
    'nm': 'NM',
    'new york': 'NY',
    'ny': 'NY',
    'north carolina': 'NC',
    'nc': 'NC',
    'north dakota': 'ND',
    'nd': 'ND',
    'northern mariana islands': 'MP',
    'mp': 'MP',
    'ohio': 'OH',
    'oh': 'OH',
    'oklahoma': 'OK',
    'ok': 'OK',
    'oregon': 'OR',
    'or': 'OR',
    'palau': 'PW',
    'pw': 'PW',
    'pennsylvania': 'PA',
    'pa': 'PA',
    'puerto rico': 'PR',
    'pr': 'PR',
    'rhode island': 'RI',
    'ri': 'RI',
    'south carolina': 'SC',
    'sc': 'SC',
    'south dakota': 'SD',
    'sd': 'SD',
    'tennessee': 'TN',
    'tn': 'TN',
    'texas': 'TX',
    'tx': 'TX',
    'utah': 'UT',
    'ut': 'UT',
    'vermont': 'VT',
    'vt': 'VT',
    'virgin islands': 'VI',
    'vi': 'VI',
    'virginia': 'VA',
    'va': 'VA',
    'washington': 'WA',
    'wa': 'WA',
    'west virginia': 'WV',
    'wv': 'WV',
    'wisconsin': 'WI',
    'wi': 'WI',
    'wyoming': 'WY',
    'wy': 'WY'
  };

  ContactParser.prototype.parse = function(address) {
    var addressRegex, canadianPostalRegex, emailRegex, extraInfo, field, fields, i, indexes, matches, phoneRegex, result, streetNameRegex, trim, usZipRegex, usedFields, websiteRegex, _i, _len, _ref;
    result = new ContactParserResult;
    indexes = {};
    usedFields = [];
    trim = function(txt) {
      return (txt || '').replace(/^\s+|\s+$/g, '');
    };
    canadianPostalRegex = /[a-z]\d[a-z]\s*\d[a-z]\d/i;
    usZipRegex = /\d\d\d\d\d/;
    emailRegex = /(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/;
    websiteRegex = /(http|www)\S+/;
    streetNameRegex = /\s(dr\.{0,1}|drive|st\.{0,1}|street)(\s|$)/i;
    phoneRegex = /(\d\d\d)[ \-\.](\d\d\d)[ \-\.](\d\d\d\d)/;
    if (canadianPostalRegex.test(address)) {
      matches = address.match(canadianPostalRegex);
      result.postal = matches[0];
      address = address.replace(matches[0], ',');
    }
    if (usZipRegex.test(address)) {
      matches = address.match(usZipRegex);
      result.postal = matches[0];
      address = address.replace(matches[0], ',');
    }
    fields = address.split(/\s*[,\n\|]\s*/);
    result.name = trim(fields[0]);
    fields.shift;
    addressRegex = /^\d+\s+\D+/;
    for (i = _i = 0, _len = fields.length; _i < _len; i = ++_i) {
      field = fields[i];
      field = trim(field);
      if (emailRegex.test(field)) {
        result.email = field;
        indexes['email'] = i;
        usedFields.push(i);
      } else if (phoneRegex.test(field)) {
        matches = phoneRegex.exec(field);
        result.phone = "(" + matches[1] + ") " + matches[2] + "-" + matches[3];
        indexes['phone'] = i;
        usedFields.push(i);
      } else if (addressRegex.test(field)) {
        result.address = field;
        indexes['address'] = i;
        usedFields.push(i);
        matches = result.address.match(streetNameRegex);
        if (matches) {
          if (result.address.indexOf(matches[0]) < result.address.length - matches[0].length - 1) {
            extraInfo = result.address.substring(result.address.indexOf(matches[0]) + matches[0].length);
            result.city = trim(extraInfo);
            result.address = result.address.substring(0, result.address.indexOf(matches[0]) + matches[0].length - 1);
          }
        }
      } else if (websiteRegex.test(field)) {
        result.website = field;
        if (result.website.indexOf('http') !== 0) {
          result.website = "http://" + result.website;
        }
        indexes['website'] = i;
        usedFields.push(i);
      } else if (field.toLowerCase() in canadianProvinces) {
        result.province = canadianProvinces[field.toLowerCase()];
        result.country = 'Canada';
        indexes['province'] = i;
        usedFields.push(i);
      } else if (field.toLowerCase() in americanStates) {
        result.province = americanStates[field.toLowerCase()];
        result.country = 'USA';
        indexes['province'] = i;
        usedFields.push(i);
      }
    }
    if (!result.city && indexes['province']) {
      result.city = trim(fields[indexes['province'] - 1]);
      usedFields.push(indexes['province'] - 1);
    }
    if (indexes['address']) {
      i = indexes['address'];
      while (i + 1 <= fields.length && (_ref = i + 1, __indexOf.call(usedFields, _ref) < 0)) {
        i++;
        if (trim(fields[i]) !== '') {
          result.address = "" + result.address + ", " + (trim(fields[i]));
        }
      }
    }
    return result;
  };

  return ContactParser;

})();

module.exports = function() {
  return new ContactParser;
};
