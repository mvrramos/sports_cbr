const express = require('express');
const cors = require('cors');
const app = express();
const mercadopago = require('mercadopago');

mercadopago.configurations.setAccessToken('TEST-365231053834689-093021-8368a0522bec2b85e05eae785f0ab1ea-242199912');

app.use(express.json());
app.use(cors());

app.post('/process_payment', async (req, res) => {
  const paymentData = {
    transaction_amount: Number(req.body.transactionAmount),
    token: req.body.token,
    description: 'Descrição do produto',
    installments: Number(req.body.installments),
    payment_method_id: req.body.paymentMethodId,
    issuer_id: req.body.issuerId,
    payer: {
      email: req.body.payer.email,
      identification: {
        type: req.body.payer.identification.type,
        number: req.body.payer.identification.number
      }
    }
  };

  try {
    const payment = await mercadopago.payment.create(paymentData);
    res.status(200).json(payment.response);
  } catch (error) {
    res.status(500).json(error);
  }
});

// Inicia o servidor
app.listen(3000, () => {
  console.log('Server running on port 3000');
});
