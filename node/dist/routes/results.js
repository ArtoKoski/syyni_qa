"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const fs_1 = __importDefault(require("fs"));
const router = (0, express_1.Router)();
function loadResults() {
    return JSON.parse(fs_1.default.readFileSync('./reports/results.json', 'utf8'));
}
router.get('/', (req, res) => {
    const results = loadResults();
    let totalTests = 0;
    let passedTests = 0;
    let failedTests = 0;
    const walkSuites = (suites) => {
        for (const suite of suites) {
            if (suite.specs) {
                for (const spec of suite.specs) {
                    totalTests++;
                    if (spec.ok) {
                        passedTests++;
                    }
                    else {
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
router.get('/failed-tests', (req, res) => {
    const results = loadResults();
    const failedTests = [];
    const walkSuites = (suites) => {
        for (const suite of suites) {
            if (suite.specs) {
                for (const spec of suite.specs) {
                    if (!spec.ok) {
                        const test = spec.tests?.[0];
                        const result = test?.results?.[0];
                        failedTests.push({
                            name: spec.title,
                            error: result?.error?.message ??
                                'Unknown error',
                        });
                    }
                }
            }
            if (suite.suites) {
                walkSuites(suite.suites);
            }
        }
    };
    walkSuites(results.suites);
    res.json(failedTests);
});
router.get('/slowest-tests', (req, res) => {
    const results = loadResults();
    const tests = [];
    const walkSuites = (suites) => {
        for (const suite of suites) {
            if (suite.specs) {
                for (const spec of suite.specs) {
                    const test = spec.tests?.[0];
                    const result = test?.results?.[0];
                    tests.push({
                        name: spec.title,
                        duration: result?.duration ?? 0,
                    });
                }
            }
            if (suite.suites) {
                walkSuites(suite.suites);
            }
        }
    };
    router.get('/ping', (req, res) => {
        res.json({
            status: 'ok',
        });
    });
    walkSuites(results.suites);
    tests.sort((a, b) => b.duration - a.duration);
    res.json(tests.slice(0, 5));
});
exports.default = router;
