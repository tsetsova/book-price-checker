require 'book_price_checker'
require 'fileutils'

describe BookPriceChecker do
  before(:each) do
    FileUtils.rm 'test.txt', force: true
    FileUtils.touch('test.txt')
  end

  after(:all) { FileUtils.rm 'test.txt', force: true }

  let(:book_price_checker) { described_class.new('test.txt') }

  it '#title' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    book_price_checker.watch(url1, 1.99)
    expect(book_price_checker.title(url1)).to eq 'The Last Tudor'
  end

  it '#current_price' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    book_price_checker.watch(url1, 1.99)
    expect(book_price_checker.current_price(url1)).to eq 3.99
  end

  it '#status' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    url2 = 'https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1'
    book_price_checker.watch(url1, 1.99)
    book_price_checker.watch(url2, 5.00)
    expected = { 'The Last Tudor'   => { cheap?: false },
                 'Brand New Friend' => { cheap?: true } }
    expect(book_price_checker.status).to eq expected
  end

  it '#watch' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    url2 = 'https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1'
    book_price_checker.watch(url1, 1.99)
    book_price_checker.watch(url2, 5.00)
    book_price_checker.unwatch('The Last Tudor')
    expected = { 'Brand New Friend' => { cheap?: true } }
    expect(book_price_checker.status).to eq expected
  end
end
