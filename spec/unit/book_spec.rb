require 'book'

describe Book do
  it '#get_book_details' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    book = Book.new(url1, 1.99)

    expected = { 'The Last Tudor' => { current_price: 3.99,
                                       desired_price: 1.99,
                                       url:           url1 } }

    expect(book.details).to eq expected
  end

  it '#cheap_enough?' do
    url1 = 'https://www.amazon.co.uk/dp/B01MSLFA03/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1'
    book = Book.new(url1, 1.99)
    expect(book.cheap_enough?). to eq false
  end
end
