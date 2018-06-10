require 'book_price_checker'
require 'fileutils'

describe BookPriceChecker do

  before(:each) {
    FileUtils.rm "test.txt", force: true
    FileUtils.touch("test.txt")
  }

  let(:book_price_checker) { described_class.new("test.txt")}

  it "#get_book_details" do
    url_1 = "https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1"
    url_2 = "https://www.amazon.co.uk/dp/B07D8YXWBY/ref=sspa_dk_detail_3?psc=1"
    book_price_checker.watch(url_1)
    book_price_checker.watch(url_2)
    expected = {"The Last Tudor"=>3.99, "Brand New Friend"=>0.99}
    expect(book_price_checker.get_book_details).to eq expected
  end
  
  it "#watch" do
    url = "url"
    book_price_checker.watch(url)
    expect(book_price_checker.list_urls.first).to eq url
  end
end
