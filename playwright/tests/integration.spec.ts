import { test, expect } from '@playwright/test';

test('Order creation trough API', async ({ request }) => {

  const order = {
    customerId: 1001,
    items: [
      {
        productId: 500,
        quantity: 2
      }
    ]
  };

  const response = await request.post(
    'https://verkkokauppa-chi.vercel.app/',
    {
      data: order
    }
  );

  expect(response.status()).toBe(201);

  const body = await response.json();

  expect(body.orderId).toBeDefined();
  expect(body.status).toBe('Created');
});