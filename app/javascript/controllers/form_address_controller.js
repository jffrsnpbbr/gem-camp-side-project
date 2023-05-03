import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-address"
export default class extends Controller {

  static targets = ['selectAddressRegion', 'selectAddressProvince', 'selectAddressCity', 'selectAddressBarangay', 'selectGenre']
  connect() {
    (async () => {
      const regions = await this.fetchRegions();
      await this.updateSelectRegion(regions);

      if (window.location.pathname.split('/').includes('edit')) {
        const {
          address_region_id,
          address_province_id,
          address_city_id,
          address_barangay_id,
          genre
        } = await this.fetchBookAddressData();

        this.selectAddressRegionTarget.value = address_region_id

        const provinces = await this.fetchProvinces(address_region_id);
        this.updateSelectProvince(provinces);
        this.selectAddressProvinceTarget.value = address_province_id;

        const cities = await this.fetchCities(address_province_id);
        this.updateSelectCity(cities);
        this.selectAddressCityTarget.value = address_city_id;

        const barangays = await this.fetchBarangays(address_city_id);
        this.updateSelectBarangay(barangays);
        this.selectAddressBarangayTarget.value = address_barangay_id

        this.selectGenreTarget.value = genre;
      }
    })();
  }



  resetSelectOptions(target) {

    console.info('resetSelectOptions')
    while(target.options.length > 1) {
      // console.log('target', target.options[1]);
      target.options[1].remove();
    }/**/

  }

  async handleChangeSelectRegion(e) {
    console.log(e.target.value);
    const regionId = e.target.value;
    const provinces = await this.fetchProvinces(regionId);
    await this.updateSelectProvince(provinces);
  }

  async handleChangeSelectProvince(e) {
    const provinceId = e.target.value;
    const cities = await this.fetchCities(provinceId);
    await this.updateSelectCity(cities);
  }

  async handleChangeSelectCity(e) {
    console.info('handleChangeSelectCity')
    const cityId = e.target.value;
    const barangays = await this.fetchBarangays(cityId);
    await this.updateSelectBarangay(barangays);
  }
  
  async fetchBookAddressData() {
    const response = await fetch(window.location.pathname, {
      method: 'GET',
      headers: {
          'Accept': 'application/json',
      }
    });
    return await response.json();
  }

  async fetchRegions() {
    const response = await fetch(`/api/v1/regions`);
    return await response.json();
  }

  async fetchProvinces(regionId) {
    const response = await fetch(`/api/v1/regions/${regionId}/provinces`);
    return await response.json();
  }

  async fetchCities(proviceId) {
    const response = await fetch(`/api/v1/provinces/${proviceId}/cities`);
    return await response.json();
  }

  async fetchBarangays(cityId) {
    const response = await fetch(`/api/v1/cities/${cityId}/barangays`);
    return await response.json();
  }

  async updateSelectRegion(regions) {
    const selectRegion = this.selectAddressRegionTarget

    this.resetSelectOptions(selectRegion);
    this.resetSelectOptions(this.selectAddressProvinceTarget);
    this.resetSelectOptions(this.selectAddressCityTarget);
    this.resetSelectOptions(this.selectAddressBarangayTarget);
    

    await regions.forEach(region => {
      const option = document.createElement('option')
      option.textContent = region.name
      option.value = region.id
      selectRegion.appendChild(option);
    });
  }


  async updateSelectProvince(provinces) {
    const selectProvince = this.selectAddressProvinceTarget
    
    this.resetSelectOptions(selectProvince);
    this.resetSelectOptions(this.selectAddressCityTarget);
    this.resetSelectOptions(this.selectAddressBarangayTarget);

    await provinces.forEach(province => {
      const option = document.createElement('option')
      option.textContent = province.name
      option.value = province.id
      selectProvince.appendChild(option);
    });
  }

  async updateSelectCity(cities) {
    const selectCity = this.selectAddressCityTarget

    this.resetSelectOptions(selectCity);
    this.resetSelectOptions(this.selectAddressBarangayTarget);

    await cities.forEach(city => {
      const option = document.createElement('option')
      option.textContent = city.name
      option.value = city.id
      selectCity.appendChild(option);
    });
  }

  async updateSelectBarangay(barangays) {
    const selectBarangay = this.selectAddressBarangayTarget
    this.resetSelectOptions(selectBarangay);
    await barangays.forEach(barangay => {
      const option = document.createElement('option')
      option.textContent = barangay.name
      option.value = barangay.id
      selectBarangay.appendChild(option);
    });
  }


}
