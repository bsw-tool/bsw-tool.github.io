export default class App {
  constructor(title) {
    this.title = title;
  }

  run() {
    document.addEventListener('load', () => {
      App._main();
    });
  }

  _main() {
    console.log(`Hello, ${this.title}!`);
    document.title = this.title;
  }
}