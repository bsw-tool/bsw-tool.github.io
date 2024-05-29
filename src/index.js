import App from '../framework/app.js'

class MyApp extends App{

  _main(){
    super();
    // Get a reference to the <body> element
    const body = document.body;

    // Remove all child nodes from the <body> element
    while (body.firstChild) {
      body.removeChild(body.firstChild);
    }
  }

}


const app = new MyApp("bsw tool");
app.run();