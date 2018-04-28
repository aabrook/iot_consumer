import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'), {
  apiUrl: process.env.ELM_APP_API_URL || ''
});

registerServiceWorker();
