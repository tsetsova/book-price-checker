require 'book'

describe Book do
  before(:all) do
    VCR.configure do |config|
      config.cassette_library_dir = 'fixtures/vcr_cassettes'
      config.hook_into :faraday
    end
  end

  it '#get_book_details' do
    VCR.use_cassette('amazon_webpage_1') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book = Book.new(url1, 1.99)

      expected = { title: 'The Last Tudor',
                   current_price: 3.99,
                   desired_price: 1.99,
                   url:           url1 }

      expect(book.details).to eq expected
    end
  end

  it '#cheap_enough?' do
    VCR.use_cassette('amazon_webpage_1') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book = Book.new(url1, 1.99)
      expect(book.cheap_enough?). to eq false
    end
  end
end
