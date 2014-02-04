require File.expand_path('../../spec_helper', __FILE__)

describe AssetRole do
  dataset :pages, :assets, :asset_roles
  
  let(:page) { pages(:pictured) }
  let(:asset) { assets(:test1) }
  
  context "rendering assets tags with roles attribute" do
    it "assets:each roles='portfolio'" do
      page.should render('<r:assets:each role="portfolio"><r:asset:id />,</r:assets:each>').as( "#{asset_id(:test1)}}," )
    end
  end


end
