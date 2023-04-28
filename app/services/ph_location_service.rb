class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def fetch_region
    request = RestClient.get("#{url}/regions/")
    data = JSON.parse(request.body)
    data.each do |region|
      address_region = Address::Region.find_or_initialize_by(code: region['code'])
      address_region.name = region['name']
      address_region.save
    end
  end

  def fetch_provinces
    request = RestClient.get("#{url}/provinces")
    data = JSON.parse(request.body)
    data.each do |province|
      region = Address::Region.find_by_code(province['regionCode'])
      address_province = Address::Province.find_or_initialize_by(code: province['code'])
      address_province.name = province['name']
      address_province.region = region
      address_province.save
    end
  end

  def fetch_districts
    request = RestClient.get("#{url}/districts/")
    data = JSON.parse(request.body)
    data.each do |district|
      region = Address::Region.find_by(code: district['regionCode'])
      address_district = Address::Province.find_or_initialize_by(code: district['code'])
      address_district.name = district['name']
      address_district.region = region
      address_district.save
    end
  end
end