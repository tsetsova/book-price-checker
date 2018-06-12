require 'book_price_checker'
require 'fileutils'

describe BookPriceChecker do
  before(:each) do
    FileUtils.rm 'test.txt', force: true
    FileUtils.touch('test.txt')
  end

  after(:all) {FileUtils.rm 'test.txt', force: true}

  let(:book_price_checker) { described_class.new('test.txt') }

  it '#get_book_details' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    url2 = 'https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1'
    book_price_checker.watch(url1, 1.99)
    book_price_checker.watch(url2, 2.00)
    expected = { 'The Last Tudor' => { current_price: 3.99,
                                       desired_price: 1.99,
                                       url:           url1 },
                 'Brand New Friend' => { current_price: 2.99,
                                         desired_price: 2.00,
                                         url:           url2 } }
    expect(book_price_checker.book_details).to eq expected
  end

  it '#watch' do
    url = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    book_price_checker.watch(url, 4.00)
    expect(book_price_checker.cheap_enough?('The Last Tudor')).to eq true
  end
end
