import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    'selectAddressRegion',
    'selectAddressProvince',
    'selectAddressCity',
    'selectAddressBarangay'
  ]
  connect() {
      console.log('connected');
      // const regions = this.fetchRegions();
      // console.log('after fetch')
    // this.updateSelectRegion()
    //   .then(() => this.setSelectOptionAddressInitialValue(this.selectAddressRegionTarget))
    //   .then(() => this.updateSelectProvince()
    //     .then(() => this.setSelectOptionAddressInitialValue(this.selectAddressProvinceTarget)))
    //       // .then(() => this.updateSelectCity()).then(() => this.setSelectOptionAddressInitialValue(this.selectAddressCityTarget))
    //

    (async () =>{
      await this.updateSelectRegion();
      await this.updateSelectProvince();
    })();

  }

  handleChangeSelectRegion() {
    this.updateSelectProvince();
  }

  removeOptions(selectElement) {
    while(selectElement.options.length > 1) { selectElement.remove(1); }
  }
  createSelectOptionAddress(target, data) {
    let option = document.createElement('option');
    option.value = data.id
    option.text = data.name
    target.appendChild(option);
  }
  setSelectOptionAddressInitialValue(target) {
    let optionId = target.dataset.addressInitialOptionId
    target.value = optionId;
    // let option = target.querySelector(`option[value="${optionId}"]`)
    // option.selected = true;
  }


  updateSelectRegion() {
    this.removeOptions(this.selectAddressRegionTarget)
    this.removeOptions(this.selectAddressProvinceTarget)
    this.removeOptions(this.selectAddressCityTarget)
    this.removeOptions(this.selectAddressBarangayTarget)
    return this.fetchRegions()
      .then(regions => regions
        .forEach(region => this.createSelectOptionAddress(this.selectAddressRegionTarget, region)));
  }
  //
  async updateSelectProvince() {
    console.log('updateselectprovince')
    if (this.selectAddressRegionTarget.value) {
      this.removeOptions(this.selectAddressProvinceTarget)
      this.removeOptions(this.selectAddressCityTarget)
      this.removeOptions(this.selectAddressBarangayTarget)

      this.fetchProvinces().then(provinces => provinces.forEach(province => this.createSelectOptionAddress(this.selectAddressProvinceTarget, province)))
    }
  }

  // updateSelectCity() {
  //   if (this.selectAddressProvinceTarget.value) {
  //     this.removeOptions(this.selectAddressCityTarget)
  //     this.removeOptions(this.selectAddressBarangayTarget)
  //
  //     let cities = await this.fetchCities();
  //     cities.forEach(city => this.createSelectOptionAddress(this.selectAddressCityTarget, city));
  //   }
  // }

  // updateSelectBarangay() {
  //   // if (this.selectAddressCityTarget.value) {
  //   //   this.removeOptions(this.selectAddressBarangayTarget);
  //   //   let barangays = await this.fetchBarangays();
  //   //   barangays.forEach(barangay => this.createSelectOptionAddress(this.selectAddressBarangayTarget, barangay));
  //   // }
  // }

  // async fetchRegions() {
  //   console.log('fetchRegions')
  //   fetch('/api/v1/regions', { method: 'get' })
  //     .then(response => response.json()).then(data => console.log(data))
  // }

  fetchRegions() {
    console.log('fetchRegions')
    return fetch('/api/v1/regions', { method: 'get' })
      .then(response => response.json())
      .catch(error=> console.log(error));
    // try {
    //   const response = await fetch('/api/v1/regions', { method: 'get' });
    //   return await response.json();
    // } catch(error) {
    //   console.log(error);
    // }
  }
  //
  fetchProvinces() {
    return fetch(`/api/v1/regions/${regionId}/provinces`, { method: 'get' })
      .then(response => response.json())
      .catch(error=> console.log(error));

    // try {
    //   const regionId = this.selectAddressRegionTarget.value;
    //   console.log(regionId)
    //   let response = await fetch(`/api/v1/regions/${regionId}/provinces`, { method: 'get' })
    //   return await response.json();
    // } catch(error) {
    //   console.log(error);
    // }
  }
  //
  // async fetchCities() {
  //   try {
  //     let response = await fetch(`/api/v1/provinces/${this.selectAddressProvinceTarget.value}/cities`, { method: 'get' });
  //     return  await response.json();
  //   } catch(error) {
  //     console.log(error);
  //   }
  // }
  //
  // async fetchBarangays() {
  //   try {
  //     const response = await fetch(`/api/v1/cities/${this.selectAddressCityTarget.value}/barangays`, { method: 'get' });
  //     return await response.json();
  //   } catch(error){
  //     console.log(error);
  //   }
  // }
}
