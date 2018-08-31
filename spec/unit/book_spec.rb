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
      url = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book = Book.new(url, 1.99)
      book.scrape_details

      expect(book.title).to eq "The Last Tudor"
      expect(book.current_price).to eq(3.99)
      expect(book.desired_price).to eq(1.99)
      expect(book.url).to eq(url)
    end
  end

  it '#cheap_enough?' do
    VCR.use_cassette('amazon_webpage_1') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book = Book.new(url1, 1.99)
      book.scrape_details

      expect(book.cheap_enough?). to eq false
    end
  end
end
