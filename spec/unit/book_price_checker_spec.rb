require 'book_price_checker'
require_relative '../../database_setup'
require 'fileutils'
require 'faraday'
require 'vcr'

describe BookPriceChecker do
  before(:all) do
    @db_setup = DatabaseSetup.new

    VCR.configure do |config|
      config.cassette_library_dir = 'fixtures/vcr_cassettes'
      config.hook_into :faraday
    end
  end

  before(:each) do
    FileUtils.rm 'test.txt', force: true
    FileUtils.touch('test.txt')
    @db_setup.create_db_in_memory
  end

  after(:all) do
    FileUtils.rm 'test.txt', force: true
    @db_setup.teardown
  end

  let(:book_price_checker) { described_class.new('test.txt', Database.new) }

  it '#title' do
    VCR.use_cassette('amazon_webpage_1') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book_price_checker.watch(url1, 1.99)
      expect(book_price_checker.title(url1)).to eq 'The Last Tudor'
    end
  end

  it '#current_price' do
    VCR.use_cassette('amazon_webpage_2') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book_price_checker.watch(url1, 1.99)
      expect(book_price_checker.current_price(url1)).to eq 3.99
    end
  end

  it '#status' do
    VCR.use_cassette('amazon_two_webpages') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      url2 = 'https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1'
      book_price_checker.watch(url2, 5.00)
      book_price_checker.watch(url1, 1.99)
      expected = { books: [{ title: 'Brand New Friend',
                             cheap?: true },
                           { title: 'The Last Tudor',
                             cheap?: false }] }
      expect(book_price_checker.watched_books).to eq expected
    end
  end

  it '#watch' do
    VCR.use_cassette('amazon_two_webpages') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      url2 = 'https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1'
      book_price_checker.watch(url1, 1.99)
      book_price_checker.watch(url2, 5.00)
      book_price_checker.unwatch('The Last Tudor')
      expected = { books: [{ title: 'Brand New Friend', cheap?: true }] }
      expect(book_price_checker.watched_books).to eq expected
    end
  end
end
