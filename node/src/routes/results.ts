import { Router } from 'express';
import fs from 'fs';

console.log('Results router loaded');

const router = Router();

function loadResults() {
  return JSON.parse(
    fs.readFileSync(
      './reports/results.json',
      'utf8'
    )
  );
}

router.get('/', (req, res) => {
  const results = loadResults();

  let totalTests = 0;
  let passedTests = 0;
  let failedTests = 0;

  const walkSuites = (suites: any[]) => {
    for (const suite of suites) {
      if (suite.specs) {
        for (const spec of suite.specs) {
          totalTests++;

          if (spec.ok) {
            passedTests++;
          } else {
            failedTests++;
          }
        }
      }

      if (suite.suites) {
        walkSuites(suite.suites);
      }
    }
  };

  walkSuites(results.suites);

  res.json({
    totalTests,
    passedTests,
    failedTests,
    lastRun: results.stats.startTime,
  });
});

export default router;