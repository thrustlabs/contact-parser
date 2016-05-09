###
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

###

class ContactParser

  class ContactParserResult
    constructor: () ->
      @name = ''
      @email = ''
      @province = ''
      @country = ''
      @address = ''
      @city = ''
      @postal = ''
      @website = ''
      @phone = ''

    score: () ->
      return 0 if !@address
      return 50 if @address && @city && !@province && !@postal && !@country
      return 80 if @address && @city && @province && !@postal && !@country
      return 90 if !@phone || !@email || !@website
      return 100

  canadianProvinces = {
    'british_columbia': 'BC', 'bc': 'BC',
    'alberta': 'AB', 'ab': 'AB',
    'saskatchewan': 'sk', 'sk': 'SK',
    'manitoba': 'MB', 'mb': 'MB',
    'ontario': 'ON', 'on': 'ON'
    'quebec': 'QC', 'qc': 'QC',
    'newfoundland': 'NL', 'newfoundland_and_labrador': 'NL', 'labrador': 'NL', 'nl': 'NL',
    'new_brunswick': 'NB', 'nb': 'NB',
    'prince_edward_island': 'PE', 'PEI': 'PE', 'pe': 'PE',
    'nova_scotia': 'NS', 'ns': 'NS',
    'yukon_territories': 'YT', 'yukon': 'YT', 'yt': 'YT',
    'northwest_territories': 'NT', 'nt': 'NT',
    'nunavut': 'NU', 'nu': 'NU'
  }

  americanStates = {
    'alabama': 'AL', 'al': 'AL',
    'alaska': 'AK', 'ak': 'AK',
    'american_samoa': 'AS', 'as': 'AS',
    'arizona': 'AZ', 'az': 'AZ',
    'arkansas': 'AR', 'ar': 'AR',
    'california': 'CA', 'ca': 'CA',
    'colorado': 'CO', 'co': 'CO',
    'connecticut': 'CT', 'ct': 'CT',
    'delaware': 'DE', 'de': 'DE',
    'district_of_columbia': 'DC', 'd.c.': 'DC', 'dc': 'DC',
    'federated_states_of_micronesia': 'FM', 'fm': 'FM',
    'florida': 'FL', 'fl': 'FL',
    'georgia': 'GA', 'ga': 'GA',
    'guam': 'GU', 'gu': 'GU',
    'hawaii': 'HI', 'hi': 'HI',
    'idaho': 'ID', 'id': 'ID',
    'illinois': 'IL', 'il': 'IL',
    'indiana': 'IN', 'in': 'IN',
    'iowa': 'IA', 'ia': 'IA',
    'kansas': 'KS', 'ks': 'KS',
    'kentucky': 'KY', 'ky': 'KY',
    'louisiana': 'LA', 'la': 'LA',
    'maine': 'ME', 'me': 'ME',
    'marshall_islands': 'MH', 'mh': 'MH',
    'maryland': 'MD', 'md': 'MD',
    'massachusetts': 'MA', 'ma': 'MA',
    'michigan': 'MI', 'mi': 'MI',
    'minnesota': 'MN', 'mn': 'MN',
    'mississippi': 'MS', 'ms': 'MS',
    'missouri': 'MO', 'mo': 'MO',
    'montana': 'MT', 'mt': 'MT',
    'nebraska': 'NE', 'ne': 'NE',
    'nevada': 'NV', 'nv': 'NV',
    'new_hampshire': 'NH', 'nh': 'NH',
    'new_jersey': 'NJ', 'nj': 'NJ',
    'new_mexico': 'NM', 'nm': 'NM',
    'new_york': 'NY', 'ny': 'NY',
    'north_carolina': 'NC', 'nc': 'NC',
    'north_dakota': 'ND', 'nd': 'ND',
    'northern_mariana_islands': 'MP', 'mp': 'MP',
    'ohio': 'OH', 'oh': 'OH',
    'oklahoma': 'OK', 'ok': 'OK',
    'oregon': 'OR', 'or': 'OR',
    'palau': 'PW', 'pw': 'PW',
    'pennsylvania': 'PA', 'pa': 'PA',
    'puerto_rico': 'PR', 'pr': 'PR',
    'rhode_island': 'RI', 'ri': 'RI',
    'south_carolina': 'SC', 'sc': 'SC',
    'south_dakota': 'SD', 'sd': 'SD',
    'tennessee': 'TN', 'tn': 'TN',
    'texas': 'TX', 'tx': 'TX',
    'utah': 'UT', 'ut': 'UT',
    'vermont': 'VT', 'vt': 'VT',
    'virgin_islands': 'VI', 'vi': 'VI',
    'virginia': 'VA', 'va': 'VA',
    'washington': 'WA', 'wa': 'WA',
    'west_virginia': 'WV', 'wv': 'WV',
    'wisconsin': 'WI', 'wi': 'WI',
    'wyoming': 'WY', 'wy': 'WY'
  }

  parse: (address) ->
    result = new ContactParserResult

    if address is undefined || address is null || address.trim() == ''
      return result

    indexes = {}
    usedFields = []

    trim = (txt) ->
      return (txt || '').replace(/^\s+|\s+$/g, '')

    canadianPostalRegex = /[a-z]\d[a-z]\s*\d[a-z]\d/i
    usZipRegex = /\w(?:,\s*|\s+)(\d\d\d\d\d(-\d\d\d\d){0,1})/ # Check that zip follows *something* so it's not confused with a street #
    emailRegex = /(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/i
    websiteRegex = /(http|www)\S+/

    streetNameRegex = /\s(dr\.{0,1}|drive|st\.{0,1}|street|(?:alle?y)|(?:app(?:roach)?)|(?:arc(?:ade)?)|(?:av(?:e|enue)?)|(?:(?:boulevard|blvd))|(?:brow)|(?:bypa(?:ss)?)|(?:c(?:ause)?way)|(?:(?:circuit|cct))|(?:circ(?:us)?)|(?:cl(?:ose)?)|(?:co?pse)|(?:(?:corner|cnr))|(?:(?:c(?:(?:our)|r)?t|crt))|(?:cres(?:cent)?)|(?:dr(?:ive)?)|(?:esp(?:lanande)?)|(?:f(?:ree)?way)|(?:(?:frontage|frnt))|(?:(?:glade|gld))|(?:gr(?:ee)?n)|(?:(?:highway|hwy))|(?:(?:lane|ln))|(?:link)|(?:loop)|(?:mall)|(?:mews)|(?:(?:packet|pckt))|(?:p(?:ara)?de)|(?:(?:parkway|pkwy))|(?:pl(?:ace)?)|(?:prom(?:enade)?)|(?:res(?:erve)?)|(?:rise)|(?:r(?:oa)?d)|(?:row)|(?:sq(?:uare)?)|(?:st(?:reet)?)|(?:stri?p)|(?:tarn)|(?:t(?:erra)?ce)|(?:(?:thoroughfare|tfre))|(?:track?)|(?:t(?:runk)?way)|(?:vi?sta)|(?:walk)|(?:wa?y)|(?:w(?:alk)?way)|(?:yard))\s*(#\S+|((suite|unit|apt\.{0,1}|apartment)\s*\S+)){0,1}(\s|$)/i
    phoneRegex = /(\s*phone\s*\:{0,1}\s*){0,1}(\d\d\d)[ \-\.](\d\d\d)[ \-\.](\d\d\d\d)/ig
    addressRegex = /^(\w*\d\w*)+\s+.*/
    poBoxRegex = /^\s*(((P(OST)?.?\s*(O(FF(ICE)?)?)?.?\s+(B(IN|OX))?)|B(IN|OX))\s+[\d\.#\-]+)/i

    if poBoxRegex.test(address)
      matches = address.match(poBoxRegex)
      result.address = matches[0]
      address = address.replace(matches[0], ',')

    if canadianPostalRegex.test(address)
      matches = address.match(canadianPostalRegex)
      result.postal = matches[0]
      address = address.replace(matches[0], ',')
    if usZipRegex.test(address)
      matches = address.match(usZipRegex)
      result.postal = matches[1]
      address = address.replace(matches[1], ',')

    if matches = emailRegex.exec(address)
      result.email = matches[0]
      address = address.replace(matches[0], ',')

    if matches = phoneRegex.exec(address)
      # Is there another, maybe better match?
      secondCheck = phoneRegex.exec(address)
      if secondCheck && matches[0].length < secondCheck[0].length
        matches = secondCheck
      result.phone = "(#{matches[2]}) #{matches[3]}-#{matches[4]}"
      address = address.replace(matches[0], ',')

    fields = address.split(/\s*[,\n\|\u2022\u2219]\s*/)
    if !addressRegex.test(trim(fields[0]))
      result.name = trim(fields[0])
      fields.shift

    for field, i in fields
      field = trim(field)
      if !result.address && addressRegex.test(field)
        result.address = field
        indexes['address'] = i
        usedFields.push(i)
        matches = result.address.match(streetNameRegex)
        if matches
          if result.address.indexOf(matches[0]) < result.address.length - matches[0].length - 1
            extraInfo = result.address.substring(result.address.indexOf(matches[0]) + matches[0].length)
            result.city = trim(extraInfo)
            result.address = trim(result.address.substring(0, result.address.indexOf(matches[0]) + matches[0].length - 1))
      else if websiteRegex.test(field)
        result.website = field
        result.website = "http://#{result.website}" if result.website.indexOf('http') != 0
        indexes['website'] = i
        usedFields.push(i)
      else
        subfields = fields[i]
        for key, value of require('util')._extend({}, americanStates, canadianProvinces)
          if key.indexOf('_') > 0
            search = "(#{key.replace('_', ') (')})"
            replacement = key.replace(/[^_]+/g, "$$$$")
            ri = 1
            while(replacement.indexOf("$$") >= 0)
              replacement = replacement.replace("$$", "$#{ri++}")
            subfields = subfields.replace(new RegExp(search, 'i'), replacement)
        subfields = subfields.split(/\s+/)

        for subfield, ix in subfields
          if subfield.toLowerCase() of canadianProvinces
            result.province = canadianProvinces[subfield.toLowerCase()]
            result.country = 'Canada'
            fields[i] = fields[i].replace(subfield, '')
            indexes['province'] = i + (trim(fields[i]).length > 0 ? 1 : 0)
            usedFields.push(i)
            break;
          else if subfield.toLowerCase() of americanStates
            result.province = americanStates[subfield.toLowerCase()]
            result.country = 'USA'
            fields[i] = fields[i].replace(subfield.replace('_', ' '), '')
            indexes['province'] = i + (trim(fields[i]).length > 0 ? 1 : 0)
            usedFields.push(i)
            break;

    if !result.city && indexes['province']
      possibleCity = trim(fields[indexes['province']-1])
      if (indexes['province']-1) in usedFields
        # We've used this for something else
        if indexes['address'] == indexes['province']-1
          # We've already used the field before the province for the address, so give up on city parsing.
          possibleCity = '';
      result.city = possibleCity
      usedFields.push(indexes['province']-1)

    if indexes['address']
      i = indexes['address']
      #result.address = "#{i} #{fields[i+1]} #{usedFields[i+1]} #{fields.length}"
      while i+1 <= fields.length && (i+1) not in usedFields
        i++
        if trim(fields[i]) != ''
          result.address = "#{result.address}, #{trim(fields[i])}"

    return result

module.exports = () ->
  return new ContactParser
