describe 'Contact Parser', ->

  ContactParser = require(__dirname + '/../src/contact-parser.js')

  it 'should extract the name', ->
    expectedValue = 'John Smith'
    sut = new ContactParser
    sut.parse('John Smith, 121 John St., Toronto, Ontario')
    expect(sut.name).toEqual(expectedValue)

  it 'should extract the email', ->
    expectedValue = 'bob@smith.com'
    sut = new ContactParser
    sut.parse('John Smith, 121 John St., Toronto, Ontario, bob@smith.com')
    expect(sut.email).toEqual(expectedValue)

  it 'should reformat North American phone numbers', ->
    expectedValue = '(416) 967-1111'
    sut = new ContactParser
    sut.parse('John Smith, 416.967 1111')
    expect(sut.phone).toEqual(expectedValue)

  it 'should prefix URLs with http://', ->
    expectedValue = 'http://www.thrustlabs.com'
    sut = new ContactParser
    sut.parse('John Smith, www.thrustlabs.com')
    expect(sut.website).toEqual(expectedValue)


  it 'should extract the full address', ->
    sut = new ContactParser
    sut.parse('Johnny Smith, 121 John St., Toronto, Ontario, johnny@smith.com')
    expect(sut.name).toEqual('Johnny Smith')
    expect(sut.email).toEqual('johnny@smith.com')
    expect(sut.address).toEqual('121 John St.')
    expect(sut.city).toEqual('Toronto')
    expect(sut.province).toEqual('ON')
    expect(sut.country).toEqual('Canada')

  it 'should parse the Amsterdam brewery', ->
    address = """
              Amsterdam Brewery
              info@amsterdambeer.com
              416.504.6882
              http://amsterdambeer.com
              45 Esandar Dr Toronto, ON M4G 4C5‎
              """
    sut = new ContactParser
    sut.parse(address)
    expect(sut.name).toEqual('Amsterdam Brewery')
    expect(sut.email).toEqual('info@amsterdambeer.com')
    expect(sut.address).toEqual('45 Esandar Dr')
    expect(sut.city).toEqual('Toronto')
    expect(sut.province).toEqual('ON')
    expect(sut.postal).toEqual('M4G 4C5')
    expect(sut.country).toEqual('Canada')
    expect(sut.website).toEqual('http://amsterdambeer.com')
    expect(sut.phone).toEqual('(416) 504-6882')

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
    sut.parse(address)
    expect(sut.name).toEqual('Secco Italian Bubbles')
    expect(sut.email).toEqual('seccoitalianbubbles@gmail.com')
    expect(sut.address).toEqual('19 East Birch Street, Ste 106')
    expect(sut.city).toEqual('Walla Walla')
    expect(sut.province).toEqual('WA')
    expect(sut.postal).toEqual('99362')
    expect(sut.country).toEqual('USA')
    expect(sut.website).toEqual('http://www.seccobubbles.com/')
    expect(sut.phone).toEqual('(509) 526-5230')

  it 'should parse Saltwater Farm', ->
    address = """
              Saltwater Farm Vineyard
              349 Elm St  Stonington, Connecticut 06378
              """
    sut = new ContactParser
    sut.parse(address)
    expect(sut.name).toEqual('Saltwater Farm Vineyard')
    expect(sut.email).toEqual('')
    expect(sut.address).toEqual('349 Elm St')
    expect(sut.city).toEqual('Stonington')
    expect(sut.province).toEqual('CT')
    expect(sut.postal).toEqual('06378')
    expect(sut.country).toEqual('USA')
    expect(sut.website).toEqual('')
    expect(sut.phone).toEqual('')

  it 'should parse Chamard Vineyards', ->
    address = "Chamard Vineyards | 115 Cow Hill Road | Clinton, CT 06413  Phone: 860-664-0299 |"
    sut = new ContactParser
    sut.parse(address)
    expect(sut.name).toEqual('Chamard Vineyards')
    expect(sut.email).toEqual('')
    expect(sut.address).toEqual('115 Cow Hill Road')
    expect(sut.city).toEqual('Clinton')
    expect(sut.province).toEqual('CT')
    expect(sut.postal).toEqual('06413')
    expect(sut.country).toEqual('USA')
    expect(sut.website).toEqual('')
    expect(sut.phone).toEqual('(860) 664-0299')

