import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-address"
export default class extends Controller {

  static targets = ['selectAddressRegion', 'selectAddressProvince', 'selectAddressCity', 'selectAddressBarangay']
  connect() {
    (async () => {
      const regions = await this.fetchRegions();
      await this.updateSelectRegion(regions);
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
