import fs from "fs";

const report =
  JSON.parse(
    fs.readFileSync(
      "results.json",
      "utf8",
    ),
  );

const passedTests =
  report.stats.expected;

const failedTests =
  report.stats.unexpected;

const historyItem = {

  id: Date.now(),

  source: "github",

  date:
    new Date()
      .toLocaleString(
        "fi-FI",
      ),

  totalTests:
    passedTests +
    failedTests,

  passedTests,

  failedTests,

  duration:
    report.stats.duration,
};