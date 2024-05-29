import App from '../framework/app.js'

class MyApp extends App{

  _main(){
    super._main();
  }

}


const app = new MyApp("bsw tool");
app.run();
console.log('Running...');