import App from '../framework/app.js'

class MyApp extends App{

  _main(){
    super();
  }

}


const app = new MyApp("bsw tool");
app.run();