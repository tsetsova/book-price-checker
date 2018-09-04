require 'book_price_checker'
require_relative '../../db.rb'
require 'fileutils'
require 'faraday'
require 'vcr'
require 'logger'

describe BookPriceChecker do
  before(:all) do
    VCR.configure do |config|
      config.cassette_library_dir = 'fixtures/vcr_cassettes'
      config.hook_into :faraday
    end
  end

  before(:each) do
    db.setup
  end

  after(:each) do

    db.close
  end

  let(:db) { Database.new(':memory:', Logger.new(STDERR, level: :error)) }
  let(:book_price_checker) { described_class.new(db) }

  it '#title' do
    VCR.use_cassette('amazon_webpage_1', allow_playback_repeats: true) do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book_price_checker.watch(url1, 1.99)
      watched_books = book_price_checker.watched_books[:books]
      expect(watched_books.size).to eq(1)
      expect(watched_books.first[:title]).to eq 'The Last Tudor'
    end
  end

  it '#unwatch' do
    VCR.use_cassette('amazon_webpage_1', allow_playback_repeats: true) do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book_price_checker.watch(url1, 1.99)
      book_price_checker.unwatch('The Last Tudor')
      expect(book_price_checker.watched_books[:books]).to be_empty
    end
  end

  it '#current_price' do
    VCR.use_cassette('amazon_webpage_2') do
      url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
      book_price_checker.watch(url1, 1.99)
      book_price_checker.watched_books
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
                             cheap?: true,
                             price: 2.99,
                             desired_price: 5.0 },
                           { title: 'The Last Tudor',
                             cheap?: false,
                             price: 3.99,
                             desired_price: 1.99 }] }
      expect(book_price_checker.watched_books).to eq expected
    end
  end
end
