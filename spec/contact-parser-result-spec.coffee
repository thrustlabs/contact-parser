describe 'Contact Parser Result', ->

  ContactParser = require(__dirname + '/../src/contact-parser.js')

  it 'should have a score of zero when empty', ->
    expectedValue = 0
    sut = new ContactParser
    result = sut.parse('')
    expect(result.score()).toEqual(expectedValue)

  it 'should have a score of 100 when all possible fields are set', ->
    expectedValue = 100
    sut = new ContactParser
    result = sut.parse('')
    result.address = 'something'
    result.city = 'something'
    result.postal = 'something'
    result.province = 'something'
    result.country = 'something'
    result.phone = 'something'
    result.email = 'something'
    result.website = 'something'
    expect(result.score()).toEqual(expectedValue)


  it 'should have a score of 90 when all address fields are set', ->
    expectedValue = 90
    sut = new ContactParser
    result = sut.parse('')
    result.address = 'something'
    result.city = 'something'
    result.postal = 'something'
    result.province = 'something'
    result.country = 'something'
    expect(result.score()).toEqual(expectedValue)

  it 'should have a score of 80 when all address fields besides postal and country are set', ->
    expectedValue = 80
    sut = new ContactParser
    result = sut.parse('')
    result.address = 'something'
    result.city = 'something'
    result.province = 'something'
    expect(result.score()).toEqual(expectedValue)

  it 'should have a score of 50 when only address and city are set', ->
    expectedValue = 50
    sut = new ContactParser
    result = sut.parse('')
    result.address = 'something'
    result.city = 'something'
    expect(result.score()).toEqual(expectedValue)
