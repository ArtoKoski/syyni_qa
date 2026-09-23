"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const child_process_1 = require("child_process");
const path_1 = __importDefault(require("path"));
const fs_1 = __importDefault(require("fs"));
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
const playwrightPath = path_1.default.resolve(__dirname, "../../playwright");
const reportPath = path_1.default.join(playwrightPath, "reports", "results.json");
const historyPath = path_1.default.join(playwrightPath, "reports", "history.json");
/*
 * Nykyiset tulokset
 */
app.get("/api/results", (req, res) => {
    try {
        if (!fs_1.default.existsSync(reportPath)) {
            return res.json({
                totalTests: 0,
                passedTests: 0,
                failedTests: 0,
                lastRun: "Ei raporttia",
            });
        }
        const report = JSON.parse(fs_1.default.readFileSync(reportPath, "utf8"));
        const totalTests = (report.stats?.expected ?? 0) +
            (report.stats?.unexpected ?? 0);
        const passedTests = report.stats?.expected ?? 0;
        const failedTests = report.stats?.unexpected ?? 0;
        const lastRun = fs_1.default
            .statSync(reportPath)
            .mtime
            .toLocaleString("fi-FI");
        return res.json({
            totalTests,
            passedTests,
            failedTests,
            lastRun,
        });
    }
    catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
        });
    }
});
/*
 * Testihistoria chartteja varten
 */
app.get("/api/history", (req, res) => {
    try {
        if (!fs_1.default.existsSync(historyPath)) {
            return res.json([]);
        }
        const history = JSON.parse(fs_1.default.readFileSync(historyPath, "utf8"));
        return res.json(history);
    }
    catch (error) {
        console.error(error);
        return res.status(500).json([]);
    }
});
/*
 * Käynnistä Playwright
 */
app.post("/api/run-tests", (req, res) => {
    console.log("Playwright testit käynnistetään...");
    (0, child_process_1.exec)("npx playwright test", {
        cwd: playwrightPath,
    }, (error, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        if (fs_1.default.existsSync(reportPath)) {
            try {
                const report = JSON.parse(fs_1.default.readFileSync(reportPath, "utf8"));
                const totalTests = (report.stats?.expected ?? 0) +
                    (report.stats?.unexpected ?? 0);
                const passedTests = report.stats?.expected ?? 0;
                const failedTests = report.stats?.unexpected ?? 0;
                let history = [];
                if (fs_1.default.existsSync(historyPath)) {
                    history = JSON.parse(fs_1.default.readFileSync(historyPath, "utf8"));
                }
                history.push({
                    date: new Date()
                        .toLocaleString("fi-FI"),
                    totalTests,
                    passedTests,
                    failedTests,
                });
                fs_1.default.writeFileSync(historyPath, JSON.stringify(history, null, 2));
            }
            catch (historyError) {
                console.error("Historian tallennus epäonnistui");
                console.error(historyError);
            }
        }
        if (error) {
            console.log("Testeissä epäonnistumisia.");
            return res.json({
                success: true,
                message: "Testiajo suoritettu, osa testeistä epäonnistui",
            });
        }
        return res.json({
            success: true,
            message: "Playwright testit suoritettu",
        });
    });
});
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
