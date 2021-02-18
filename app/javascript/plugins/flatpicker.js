import flatpickr from "flatpickr";

const initFlatpickr = () => {
  const inputs = document.querySelectorAll('.datepicker')
  console.log('io')
  inputs.forEach((input) => {
    console.log(input)
    flatpickr(input, {});
  })
}

export { initFlatpickr };