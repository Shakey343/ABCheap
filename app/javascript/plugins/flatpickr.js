import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
      enableTime: true,
      dateFormat: "Y-m-d H:i"
  });
}

export { initFlatpickr };
