describe 'Contact Parser', ->

  ContactParser = require(__dirname + '/../src/contact-parser.js')

  it 'should extract the name', ->
    expectedValue = 'John Smith'
    sut = new ContactParser
    result = sut.parse('John Smith, 121 John St., Toronto, Ontario')
    expect(result.name).toEqual(expectedValue)

  it 'should extract the email', ->
    expectedValue = 'bob@smith.com'
    sut = new ContactParser
    result = sut.parse('John Smith, 121 John St., Toronto, Ontario, bob@smith.com')
    expect(result.email).toEqual(expectedValue)

  it 'should reformat North American phone numbers', ->
    expectedValue = '(416) 967-1111'
    sut = new ContactParser
    result = sut.parse('John Smith, 416.967 1111')
    expect(result.phone).toEqual(expectedValue)

  it 'should prefix URLs with http://', ->
    expectedValue = 'http://www.thrustlabs.com'
    sut = new ContactParser
    result = sut.parse('John Smith, www.thrustlabs.com')
    expect(result.website).toEqual(expectedValue)


  it 'should extract the full address', ->
    sut = new ContactParser
    result = sut.parse('Johnny Smith, 121 John St., Toronto, Ontario, johnny@smith.com')
    expect(result.name).toEqual('Johnny Smith')
    expect(result.email).toEqual('johnny@smith.com')
    expect(result.address).toEqual('121 John St.')
    expect(result.city).toEqual('Toronto')
    expect(result.province).toEqual('ON')
    expect(result.country).toEqual('Canada')

  it 'should parse the Amsterdam brewery', ->
    address = """
              Amsterdam Brewery
              info@amsterdambeer.com
              416.504.6882
              http://amsterdambeer.com
              45 Esandar Dr Toronto, ON M4G 4C5‎
              """
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('Amsterdam Brewery')
    expect(result.email).toEqual('info@amsterdambeer.com')
    expect(result.address).toEqual('45 Esandar Dr')
    expect(result.city).toEqual('Toronto')
    expect(result.province).toEqual('ON')
    expect(result.postal).toEqual('M4G 4C5')
    expect(result.country).toEqual('Canada')
    expect(result.website).toEqual('http://amsterdambeer.com')
    expect(result.phone).toEqual('(416) 504-6882')

  it 'should parse Secco Italian Bubbles', ->
    address = """
              Secco Italian Bubbles
              19 East Birch Street, Ste 106
              Walla Walla, Washington 99362
              Phone: 509.526.5230
              seccoitalianbubbles@gmail.com

              http://www.seccobubbles.com/
              """
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('Secco Italian Bubbles')
    expect(result.email).toEqual('seccoitalianbubbles@gmail.com')
    expect(result.address).toEqual('19 East Birch Street, Ste 106')
    expect(result.city).toEqual('Walla Walla')
    expect(result.province).toEqual('WA')
    expect(result.postal).toEqual('99362')
    expect(result.country).toEqual('USA')
    expect(result.website).toEqual('http://www.seccobubbles.com/')
    expect(result.phone).toEqual('(509) 526-5230')

  it 'should parse Saltwater Farm', ->
    address = """
              Saltwater Farm Vineyard
              349 Elm St  Stonington, Connecticut 06378
              """
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('Saltwater Farm Vineyard')
    expect(result.email).toEqual('')
    expect(result.address).toEqual('349 Elm St')
    expect(result.city).toEqual('Stonington')
    expect(result.province).toEqual('CT')
    expect(result.postal).toEqual('06378')
    expect(result.country).toEqual('USA')
    expect(result.website).toEqual('')
    expect(result.phone).toEqual('')

  it 'should parse Chamard Vineyards', ->
    address = "Chamard Vineyards | 115 Cow Hill Road | Clinton, CT 06413  Phone: 860-664-0299 |"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('Chamard Vineyards')
    expect(result.email).toEqual('')
    expect(result.address).toEqual('115 Cow Hill Road')
    expect(result.city).toEqual('Clinton')
    expect(result.province).toEqual('CT')
    expect(result.postal).toEqual('06413')
    expect(result.country).toEqual('USA')
    expect(result.website).toEqual('')
    expect(result.phone).toEqual('(860) 664-0299')

  it 'should parse shorter blocks', ->
    address = "Hello, 123 jones st"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('Hello')
    expect(result.address).toEqual('123 jones st')

  it 'should recognize 5-4 ZIP codes', ->
    address = "Mark, 1 17th Street #5, Denver CO 12345-1234"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.postal).toEqual('12345-1234')

  it 'should work when a name is missing', ->
    address = "1 17th Street #5, Denver CO 12345-1234"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.address).toEqual('1 17th Street #5')
    expect(result.city).toEqual('Denver')
    expect(result.province).toEqual('CO')
    expect(result.postal).toEqual('12345-1234')

  it 'should work with 5 digit street addresses', ->
    address = "12345 Andrews Dr, Denver, CO 80239-4458"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.address).toEqual('12345 Andrews Dr')
    expect(result.city).toEqual('Denver')
    expect(result.province).toEqual('CO')
    expect(result.postal).toEqual('80239-4458')

  it 'should take the city out of the address if it finds it by proximity to state', ->
    address = "      710 First Street Napa, CA 94559 PHONE 707.256.3111  FAX 707.256.0864  info@heroldwines.com"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.name).toEqual('')
    expect(result.address).toEqual('710 First Street')
    expect(result.city).toEqual('Napa')
    expect(result.province).toEqual('CA')
    expect(result.postal).toEqual('94559')

  it 'should use labels as hints if available', ->
    address = "710 First Street Napa, CA 94559 FAX 707.256.0864  PHONE 707.256.3111"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.address).toEqual('710 First Street')
    expect(result.city).toEqual('Napa')
    expect(result.province).toEqual('CA')
    expect(result.postal).toEqual('94559')
    expect(result.phone).toEqual('(707) 256-3111')

  it 'should extract identifiable elements from space separated strings', ->
    address = "710 First Street Napa, CA 94559 PHONE 707.256.3111 info@testing.com"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.address).toEqual('710 First Street')
    expect(result.city).toEqual('Napa')
    expect(result.province).toEqual('CA')
    expect(result.postal).toEqual('94559')
    expect(result.phone).toEqual('(707) 256-3111')
    expect(result.email).toEqual('info@testing.com')

  it 'should treat bullet characters as separators', ->
    address = "710 First Street • Napa, CA 94559 • PHONE 707.256.3111 info@testing.com"
    sut = new ContactParser
    result = sut.parse(address)
    expect(result.address).toEqual('710 First Street')
    expect(result.city).toEqual('Napa')
    expect(result.province).toEqual('CA')
    expect(result.postal).toEqual('94559')
    expect(result.phone).toEqual('(707) 256-3111')
    expect(result.email).toEqual('info@testing.com')

  it 'should handle states with spaces in the name', ->
    address = "Adair Vineyards • 52 Allhusen Road, New Paltz, New York 12561 • 845-255-1377"
    sut = new ContactParser
    result = sut.parse(address)
    console.log result
    expect(result.name).toEqual('Adair Vineyards')
    expect(result.address).toEqual('52 Allhusen Road')
    expect(result.city).toEqual('New Paltz')
    expect(result.province).toEqual('NY')
    expect(result.postal).toEqual('12561')
    expect(result.phone).toEqual('(845) 255-1377')
