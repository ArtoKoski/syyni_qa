import { test, expect } from '@playwright/test';

test('Product search', async ({ page }) => {
  await page.goto('https://verkkokauppa-chi.vercel.app/');

  await page.fill('#search', 'Nike Pegasus 42');

  await page.keyboard.press('Enter');

  await expect(page.locator('.product'))
      .toBeVisible();
});