import { defineConfig } from "@playwright/test";


export default defineConfig({
  use: {
    screenshot: 'only-on-failure',
  },
  reporter: [
    ["html"],
    [
      "json",
      {
        outputFile: "reports/results.json",
      },
    ],
  ],
});
