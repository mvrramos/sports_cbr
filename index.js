import cors from "cors";
import express from "express";
import { MercadoPagoConfig, Preference } from 'mercadopago';
const client = new MercadoPagoConfig({ accessToken: 'APP_USR-4092734903164911-093020-1fbaf53757b9cdbb0607f982a5a977f1-242199912' });

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.send("Mercado Pago");
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.post('/create_preferences', async (req, res) => {
    try {
        const body = {
            items: [
                {
                    title: req.body.title,
                    quantity: Number(req.body.quantity),
                    unit_price: Number(req.body.unit_price),
                    currency_id: 'BRL'

                    // title: "Camisa - Teste",
                    // quantity: 1,
                    // unit_price: 200,
                    // currency_id: 'BRL'
                },
            ],
            // payer: {
            //     email: req.body.email,
            // },
            // back_urls: {
            //     success: "http://sportscbr.com.br/success",
            //     failure: "http://10.0.2.2:3000/create_preferences",
            //     pending: "http://10.0.2.2:3000/create_preferences"
            // },
            // auto_return: 'approved'
        };
        const preferences = new Preference(client);
        const result = await preferences.create({ body });
        console.log(result);
        res.json({ url: result.init_point });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Erro ao criar preferencia" });
    }

});

