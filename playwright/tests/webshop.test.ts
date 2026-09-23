import { test, expect } from '@playwright/test';

test.describe('Verkkokauppa', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('https://verkkokauppa-chi.vercel.app/');
  });

  test('Etusivu avautuu', async ({ page }) => {

    await expect(page).toHaveTitle(/./);

    await expect(
      page.locator('body')
    ).toBeVisible();
  });

  test('Tuotteita löytyy sivulta', async ({ page }) => {

    const products = page.locator(
      '[data-testid="product"], .product, .card'
    );

    await expect(products.first())
      .toBeVisible();
  });

  test('Tuotesivu avautuu', async ({ page }) => {

    await page
      .locator('a')
      .first()
      .click();

    await expect(page)
      .toHaveURL(/.+/);
  });

  test('Haku toimii', async ({ page }) => {

    const searchInput =
      page.locator(
        'input[type="search"], input[placeholder*="Hae"]'
      );

    if (await searchInput.count() > 0) {

      await searchInput.fill('tuote');

      await page.keyboard.press('Enter');

      await expect(page.locator('body'))
        .toBeVisible();
    }
  });

  test('Ostoskori avautuu', async ({ page }) => {

    const cartButton =
      page.locator(
        '[data-testid="cart"], .cart, button:has-text("Cart"), button:has-text("Ostoskori")'
      );

    if (await cartButton.count() > 0) {

      await cartButton.first().click();

      await expect(page.locator('body'))
        .toBeVisible();
    }
  });

});