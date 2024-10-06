
// SDK do Mercado Pago
import { MercadoPagoConfig } from 'mercadopago';
// Adicione as credenciais
const client = new MercadoPagoConfig({ accessToken: 'APP_USR-4694575857786169-100618-e431aa01e1afc5f164c5ea252e4f8124-2024426146' });


const preference = new Preference(client);

preference.create({
  body: {
    items: [
      {
        title: 'Meu produto',
        quantity: 1,
        unit_price: 25
      }
    ],
  }
})
.then(console.log)
.catch(console.log);

