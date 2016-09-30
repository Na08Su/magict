module HttpStatusHelper
  shared_examples 'http_status 200 ok' do
    it 'HTTP_STATUSが200であること' do
      subject
      expect(response).to be_success
      expect(response.status).to eq 200
    end
  end

  shared_examples 'http_status 302 Found' do
    it 'HTTP_STATUSが302であること' do
      subject
      expect(response.status).to eq 302
    end
  end
end
