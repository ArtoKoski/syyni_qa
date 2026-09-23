import { test, expect } from '@playwright/test';

test('Add product to shopping cart', async ({ page }) => {

  await page.goto('https://verkkokauppa-chi.vercel.app/');

  await page.getByPlaceholder('Search products').fill('Sneakers');
  await page.keyboard.press('Enter');

  await page.locator('.product-card').first().click();

  await page.getByRole('button', {
    name: 'Add to shopping cart'
  }).click();

  await expect(page.locator('.cart-counter'))
    .toHaveText('1');
});